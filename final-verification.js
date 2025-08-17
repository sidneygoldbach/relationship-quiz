const { pool, dbType } = require('./database');

async function finalVerificationPostgreSQL() {
  try {
    console.log('🔍 Verificação final do problema de opções duplicadas...');
    
    // 1. Verificar total de opções por idioma
    console.log('\n📊 Total de opções por idioma:');
    const totalByLanguage = await pool.query(`
      SELECT q.country, COUNT(ao.*) as total_options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      GROUP BY q.country
      ORDER BY q.country
    `);
    
    totalByLanguage.rows.forEach(row => {
      console.log(`  ${row.country}: ${row.total_options} opções`);
    });
    
    // 2. Verificar se há opções duplicadas (mesmo texto, mesma pergunta)
    console.log('\n🔍 Verificando opções duplicadas (mesmo texto, mesma pergunta):');
    const duplicates = await pool.query(`
      SELECT question_id, option_text, COUNT(*) as count
      FROM answer_options
      GROUP BY question_id, option_text
      HAVING COUNT(*) > 1
      ORDER BY question_id, option_text
    `);
    
    if (duplicates.rows.length > 0) {
      console.log(`⚠️ Encontradas ${duplicates.rows.length} opções duplicadas:`);
      duplicates.rows.forEach(row => {
        console.log(`  Pergunta ${row.question_id}: "${row.option_text}" (${row.count}x)`);
      });
    } else {
      console.log('✅ Não há opções duplicadas!');
    }
    
    // 3. Verificar se há opções em idioma errado
    console.log('\n🔍 Verificando opções em idioma errado:');
    
    // Português em perguntas inglesas
    const portugueseInEnglish = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'en_US' 
      AND (ao.option_text ILIKE '%prefiro%' 
           OR ao.option_text ILIKE '%preciso%' 
           OR ao.option_text ILIKE '%tento%' 
           OR ao.option_text ILIKE '%às vezes%'
           OR ao.option_text ILIKE '%comunicação%'
           OR ao.option_text ILIKE '%confiança%'
           OR ao.option_text ILIKE '%crescimento%'
           OR ao.option_text ILIKE '%abordar%'
           OR ao.option_text ILIKE '%processar%'
           OR ao.option_text ILIKE '%discutir%')
    `);
    
    // Inglês em perguntas portuguesas
    const englishInPortuguese = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'pt_BR' 
      AND (ao.option_text ILIKE '%prefer%' 
           OR ao.option_text ILIKE '%need%' 
           OR ao.option_text ILIKE '%try%' 
           OR ao.option_text ILIKE '%sometimes%'
           OR ao.option_text ILIKE '%communication%'
           OR ao.option_text ILIKE '%trust%'
           OR ao.option_text ILIKE '%growth%'
           OR ao.option_text ILIKE '%address%'
           OR ao.option_text ILIKE '%process%'
           OR ao.option_text ILIKE '%discuss%')
    `);
    
    // Inglês em perguntas espanholas
    const englishInSpanish = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'es_ES' 
      AND (ao.option_text ILIKE '%prefer%' 
           OR ao.option_text ILIKE '%need%' 
           OR ao.option_text ILIKE '%try%' 
           OR ao.option_text ILIKE '%sometimes%'
           OR ao.option_text ILIKE '%communication%'
           OR ao.option_text ILIKE '%trust%'
           OR ao.option_text ILIKE '%growth%')
    `);
    
    console.log(`  Português em perguntas inglesas: ${portugueseInEnglish.rows[0].count}`);
    console.log(`  Inglês em perguntas portuguesas: ${englishInPortuguese.rows[0].count}`);
    console.log(`  Inglês em perguntas espanholas: ${englishInSpanish.rows[0].count}`);
    
    const totalMixed = parseInt(portugueseInEnglish.rows[0].count) + 
                      parseInt(englishInPortuguese.rows[0].count) + 
                      parseInt(englishInSpanish.rows[0].count);
    
    if (totalMixed === 0) {
      console.log('✅ Todas as opções estão nos idiomas corretos!');
    } else {
      console.log(`⚠️ Total de opções em idioma errado: ${totalMixed}`);
    }
    
    // 4. Verificar distribuição de opções por pergunta
    console.log('\n📊 Distribuição de opções por pergunta (todas):');
    const optionsPerQuestion = await pool.query(`
      SELECT ao.question_id, q.country, q.question_text, COUNT(*) as total_options
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      GROUP BY ao.question_id, q.country, q.question_text
      ORDER BY ao.question_id
    `);
    
    optionsPerQuestion.rows.forEach(row => {
      const shortText = row.question_text.length > 50 ? 
        row.question_text.substring(0, 50) + '...' : 
        row.question_text;
      console.log(`  Q${row.question_id} (${row.country}): ${row.total_options} opções - "${shortText}"`);
    });
    
    // 5. Mostrar exemplos de opções por idioma
    console.log('\n📝 Exemplos de opções por idioma:');
    
    const examples = await pool.query(`
      SELECT q.country, ao.option_text
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE ao.id IN (
        SELECT MIN(ao2.id)
        FROM answer_options ao2
        JOIN questions q2 ON ao2.question_id = q2.id
        GROUP BY q2.country
      )
      ORDER BY q.country
    `);
    
    examples.rows.forEach(row => {
      const shortText = row.option_text.length > 60 ? 
        row.option_text.substring(0, 60) + '...' : 
        row.option_text;
      console.log(`  ${row.country}: "${shortText}"`);
    });
    
    // 6. Verificar se há opções órfãs
    console.log('\n🔍 Verificando opções órfãs (sem pergunta correspondente):');
    const orphanOptions = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      LEFT JOIN questions q ON ao.question_id = q.id
      WHERE q.id IS NULL
    `);
    
    if (orphanOptions.rows[0].count > 0) {
      console.log(`⚠️ Encontradas ${orphanOptions.rows[0].count} opções órfãs`);
    } else {
      console.log('✅ Não há opções órfãs!');
    }
    
    // 7. Resumo final
    console.log('\n📋 RESUMO FINAL:');
    console.log('================');
    
    const totalOptions = totalByLanguage.rows.reduce((sum, row) => sum + parseInt(row.total_options), 0);
    console.log(`Total de opções: ${totalOptions}`);
    console.log(`Opções duplicadas: ${duplicates.rows.length}`);
    console.log(`Opções em idioma errado: ${totalMixed}`);
    console.log(`Opções órfãs: ${orphanOptions.rows[0].count}`);
    
    if (duplicates.rows.length === 0 && totalMixed === 0 && parseInt(orphanOptions.rows[0].count) === 0) {
      console.log('\n🎉 PROBLEMA RESOLVIDO! Todas as opções estão corretas!');
    } else {
      console.log('\n⚠️ Ainda há problemas que precisam ser corrigidos.');
    }
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function main() {
  console.log('🚀 Iniciando verificação final...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await finalVerificationPostgreSQL();
    } else {
      console.log('📊 Usando SQLite - não implementado');
    }
    
    console.log('\n✅ Verificação concluída!');
  } catch (error) {
    console.error('❌ Erro durante a verificação:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };