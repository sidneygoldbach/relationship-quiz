const { pool, dbType } = require('./database');

async function fixDuplicateOptionsPostgreSQL() {
  try {
    console.log('🔧 Corrigindo opções duplicadas no PostgreSQL...');
    
    // Primeiro, vamos identificar as opções problemáticas
    console.log('\n🔍 Identificando opções problemáticas...');
    const problematicOptions = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.country, q.country as question_country
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE ao.question_id IN (1, 2, 3, 4, 5)
      ORDER BY ao.question_id, ao.id
    `);
    
    console.log(`Encontradas ${problematicOptions.rows.length} opções nas primeiras 5 perguntas`);
    
    // Agrupar opções por idioma baseado no texto
    const optionsByLanguage = {
      portuguese: [],
      english: [],
      spanish: []
    };
    
    problematicOptions.rows.forEach(option => {
      const text = option.option_text.toLowerCase();
      
      // Detectar idioma baseado em palavras-chave
      if (text.includes('às vezes') || text.includes('preciso') || text.includes('prefiro') || 
          text.includes('tento') || text.includes('crescimento') || text.includes('comunicação') ||
          text.includes('independência') || text.includes('lealdade') || text.includes('cuidado')) {
        optionsByLanguage.portuguese.push(option);
      } else if (text.includes('sometimes') || text.includes('need') || text.includes('prefer') ||
                text.includes('try') || text.includes('growth') || text.includes('communication') ||
                text.includes('independence') || text.includes('loyalty') || text.includes('care')) {
        optionsByLanguage.english.push(option);
      } else if (text.includes('veces') || text.includes('necesito') || text.includes('prefiero') ||
                text.includes('trato') || text.includes('crecimiento') || text.includes('comunicación') ||
                text.includes('independencia') || text.includes('lealtad') || text.includes('cuidado')) {
        optionsByLanguage.spanish.push(option);
      } else {
        // Se não conseguir detectar, assumir inglês por padrão
        optionsByLanguage.english.push(option);
      }
    });
    
    console.log(`\n📊 Opções por idioma detectado:`);
    console.log(`  Português: ${optionsByLanguage.portuguese.length}`);
    console.log(`  Inglês: ${optionsByLanguage.english.length}`);
    console.log(`  Espanhol: ${optionsByLanguage.spanish.length}`);
    
    // Verificar se existem perguntas em português e espanhol
    const questionsCheck = await pool.query(`
      SELECT country, COUNT(*) as count
      FROM questions
      GROUP BY country
      ORDER BY country
    `);
    
    console.log('\n📋 Perguntas por país:');
    questionsCheck.rows.forEach(row => {
      console.log(`  ${row.country}: ${row.count} perguntas`);
    });
    
    // Corrigir o país das opções em português
    if (optionsByLanguage.portuguese.length > 0) {
      console.log('\n🔧 Corrigindo país das opções em português...');
      
      for (const option of optionsByLanguage.portuguese) {
        await pool.query(`
          UPDATE answer_options 
          SET country = 'pt_BR'
          WHERE id = $1
        `, [option.id]);
        
        console.log(`✅ Opção ${option.id} atualizada para pt_BR: "${option.option_text.substring(0, 50)}..."`);
      }
    }
    
    // Corrigir o país das opções em espanhol
    if (optionsByLanguage.spanish.length > 0) {
      console.log('\n🔧 Corrigindo país das opções em espanhol...');
      
      for (const option of optionsByLanguage.spanish) {
        await pool.query(`
          UPDATE answer_options 
          SET country = 'es_ES'
          WHERE id = $1
        `, [option.id]);
        
        console.log(`✅ Opção ${option.id} atualizada para es_ES: "${option.option_text.substring(0, 50)}..."`);
      }
    }
    
    // Remover opções verdadeiramente duplicadas (mesmo texto, mesma pergunta, mesmo país)
    console.log('\n🗑️ Removendo opções verdadeiramente duplicadas...');
    const duplicateRemoval = await pool.query(`
      DELETE FROM answer_options 
      WHERE id IN (
        SELECT id FROM (
          SELECT id, 
                 ROW_NUMBER() OVER (
                   PARTITION BY question_id, option_text, country 
                   ORDER BY id
                 ) as rn
          FROM answer_options
        ) t 
        WHERE t.rn > 1
      )
    `);
    
    console.log(`🗑️ Removidas ${duplicateRemoval.rowCount} opções duplicadas`);
    
    // Reorganizar option_order
    console.log('\n🔄 Reorganizando ordem das opções...');
    const questions = await pool.query(`
      SELECT DISTINCT question_id 
      FROM answer_options 
      ORDER BY question_id
    `);
    
    for (const question of questions.rows) {
      const options = await pool.query(`
        SELECT id 
        FROM answer_options 
        WHERE question_id = $1 
        ORDER BY id
      `, [question.question_id]);
      
      for (let i = 0; i < options.rows.length; i++) {
        await pool.query(`
          UPDATE answer_options 
          SET option_order = $1 
          WHERE id = $2
        `, [i, options.rows[i].id]);
      }
    }
    
    console.log('✅ Ordem das opções reorganizada');
    
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
    
    // Mostrar algumas opções de exemplo após correção
    console.log('\n📝 Exemplo de opções após correção (primeiras 6):');
    const sampleOptions = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.option_order, q.country
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      ORDER BY ao.question_id, ao.option_order
      LIMIT 6
    `);
    
    sampleOptions.rows.forEach(row => {
      console.log(`  Q${row.question_id} (${row.country}) - Ordem ${row.option_order}: "${row.option_text.substring(0, 60)}..."`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function fixDuplicateOptionsSQLite() {
  return new Promise((resolve, reject) => {
    console.log('🔧 Corrigindo opções duplicadas no SQLite...');
    console.log('⚠️ Implementação SQLite não disponível ainda');
    pool.close();
    resolve();
  });
}

async function main() {
  console.log('🚀 Iniciando correção de opções duplicadas...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await fixDuplicateOptionsPostgreSQL();
    } else {
      console.log('📊 Usando SQLite');
      await fixDuplicateOptionsSQLite();
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