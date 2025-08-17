const { pool, dbType } = require('./database');

async function fixLastMixedOptionPostgreSQL() {
  try {
    console.log('🔍 Identificando a última opção em idioma errado...');
    
    // Verificar português em perguntas inglesas
    const portugueseInEnglish = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.country, q.country as question_country
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
           OR ao.option_text ILIKE '%discutir%'
           OR ao.option_text ILIKE '%através%'
           OR ao.option_text ILIKE '%contato%'
           OR ao.option_text ILIKE '%físico%'
           OR ao.option_text ILIKE '%cercanía%'
           OR ao.option_text ILIKE '%palabras%'
           OR ao.option_text ILIKE '%afirmación%'
           OR ao.option_text ILIKE '%cumplidos%')
    `);
    
    // Verificar inglês em perguntas portuguesas
    const englishInPortuguese = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.country, q.country as question_country
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
           OR ao.option_text ILIKE '%discuss%'
           OR ao.option_text ILIKE '%through%'
           OR ao.option_text ILIKE '%physical%'
           OR ao.option_text ILIKE '%touch%'
           OR ao.option_text ILIKE '%words%'
           OR ao.option_text ILIKE '%affirmation%')
    `);
    
    // Verificar inglês em perguntas espanholas
    const englishInSpanish = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.country, q.country as question_country
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'es_ES' 
      AND (ao.option_text ILIKE '%prefer%' 
           OR ao.option_text ILIKE '%need%' 
           OR ao.option_text ILIKE '%try%' 
           OR ao.option_text ILIKE '%sometimes%'
           OR ao.option_text ILIKE '%communication%'
           OR ao.option_text ILIKE '%trust%'
           OR ao.option_text ILIKE '%growth%'
           OR ao.option_text ILIKE '%through%'
           OR ao.option_text ILIKE '%physical%'
           OR ao.option_text ILIKE '%touch%'
           OR ao.option_text ILIKE '%words%'
           OR ao.option_text ILIKE '%affirmation%')
    `);
    
    console.log(`Português em inglês: ${portugueseInEnglish.rows.length}`);
    console.log(`Inglês em português: ${englishInPortuguese.rows.length}`);
    console.log(`Inglês em espanhol: ${englishInSpanish.rows.length}`);
    
    const allMixed = [...portugueseInEnglish.rows, ...englishInPortuguese.rows, ...englishInSpanish.rows];
    
    if (allMixed.length === 0) {
      console.log('✅ Não foram encontradas opções em idioma errado!');
      return;
    }
    
    console.log('\n📋 Opções em idioma errado encontradas:');
    allMixed.forEach(option => {
      console.log(`  ID ${option.id} - Q${option.question_id} (${option.question_country}): "${option.option_text}"`);
    });
    
    // Remover todas as opções em idioma errado
    console.log('\n🗑️ Removendo opções em idioma errado...');
    for (const option of allMixed) {
      await pool.query(`DELETE FROM answer_options WHERE id = $1`, [option.id]);
      console.log(`✅ Removida opção ID ${option.id}: "${option.option_text}"`);
    }
    
    // Reorganizar option_order para todas as perguntas afetadas
    console.log('\n🔄 Reorganizando ordem das opções...');
    const affectedQuestions = [...new Set(allMixed.map(opt => opt.question_id))];
    
    for (const questionId of affectedQuestions) {
      const options = await pool.query(`
        SELECT id 
        FROM answer_options 
        WHERE question_id = $1 
        ORDER BY id
      `, [questionId]);
      
      for (let i = 0; i < options.rows.length; i++) {
        await pool.query(`
          UPDATE answer_options 
          SET option_order = $1 
          WHERE id = $2
        `, [i, options.rows[i].id]);
      }
      
      console.log(`✅ Reorganizada pergunta ${questionId} (${options.rows.length} opções)`);
    }
    
    // Verificar resultado final
    console.log('\n📊 Verificando resultado final...');
    const finalCheck = await pool.query(`
      SELECT q.country, COUNT(ao.*) as total_options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      GROUP BY q.country
      ORDER BY q.country
    `);
    
    finalCheck.rows.forEach(row => {
      console.log(`  ${row.country}: ${row.total_options} opções`);
    });
    
    // Verificação final de idiomas misturados
    const finalMixedCheck = await pool.query(`
      SELECT COUNT(*) as count
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE (q.country = 'en_US' AND (
               ao.option_text ILIKE '%prefiro%' OR ao.option_text ILIKE '%preciso%' OR 
               ao.option_text ILIKE '%tento%' OR ao.option_text ILIKE '%às vezes%' OR
               ao.option_text ILIKE '%comunicação%' OR ao.option_text ILIKE '%confiança%' OR
               ao.option_text ILIKE '%crescimento%' OR ao.option_text ILIKE '%abordar%' OR
               ao.option_text ILIKE '%processar%' OR ao.option_text ILIKE '%discutir%'
             ))
          OR (q.country = 'pt_BR' AND (
               ao.option_text ILIKE '%prefer%' OR ao.option_text ILIKE '%need%' OR
               ao.option_text ILIKE '%try%' OR ao.option_text ILIKE '%sometimes%' OR
               ao.option_text ILIKE '%communication%' OR ao.option_text ILIKE '%trust%' OR
               ao.option_text ILIKE '%growth%' OR ao.option_text ILIKE '%address%' OR
               ao.option_text ILIKE '%process%' OR ao.option_text ILIKE '%discuss%'
             ))
          OR (q.country = 'es_ES' AND (
               ao.option_text ILIKE '%prefer%' OR ao.option_text ILIKE '%need%' OR
               ao.option_text ILIKE '%try%' OR ao.option_text ILIKE '%sometimes%' OR
               ao.option_text ILIKE '%communication%' OR ao.option_text ILIKE '%trust%' OR
               ao.option_text ILIKE '%growth%'
             ))
    `);
    
    if (finalMixedCheck.rows[0].count === 0) {
      console.log('\n🎉 SUCESSO! Todas as opções estão nos idiomas corretos!');
    } else {
      console.log(`\n⚠️ Ainda há ${finalMixedCheck.rows[0].count} opções em idioma errado`);
    }
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function main() {
  console.log('🚀 Iniciando correção da última opção em idioma errado...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await fixLastMixedOptionPostgreSQL();
    } else {
      console.log('📊 Usando SQLite - não implementado');
    }
    
    console.log('\n✅ Correção concluída!');
  } catch (error) {
    console.error('❌ Erro durante a correção:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };