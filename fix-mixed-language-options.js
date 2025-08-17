const { pool, dbType } = require('./database');

async function fixMixedLanguageOptionsPostgreSQL() {
  try {
    console.log('🔧 Corrigindo opções com idiomas misturados...');
    
    // Identificar opções em português que estão em perguntas inglesas
    console.log('\n🔍 Identificando opções em português em perguntas inglesas...');
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
           OR ao.option_text ILIKE '%experiências%'
           OR ao.option_text ILIKE '%entender%'
           OR ao.option_text ILIKE '%perspectiva%')
      ORDER BY ao.question_id, ao.id
    `);
    
    console.log(`Encontradas ${portugueseInEnglish.rows.length} opções em português em perguntas inglesas`);
    
    if (portugueseInEnglish.rows.length > 0) {
      // Mapear perguntas inglesas para suas equivalentes em português
      const questionMapping = {
        1: null, // Será encontrado dinamicamente
        2: null,
        3: null,
        4: null,
        5: null
      };
      
      // Encontrar perguntas equivalentes em português
      for (let englishQuestionId of [1, 2, 3, 4, 5]) {
        const portugueseQuestion = await pool.query(`
          SELECT id FROM questions 
          WHERE country = 'pt_BR' 
          AND question_order = (
            SELECT question_order FROM questions 
            WHERE id = $1 AND country = 'en_US'
          )
        `, [englishQuestionId]);
        
        if (portugueseQuestion.rows.length > 0) {
          questionMapping[englishQuestionId] = portugueseQuestion.rows[0].id;
          console.log(`📋 Pergunta ${englishQuestionId} (en_US) → Pergunta ${portugueseQuestion.rows[0].id} (pt_BR)`);
        }
      }
      
      // Mover opções para as perguntas corretas
      console.log('\n🔄 Movendo opções para perguntas em português...');
      
      for (const option of portugueseInEnglish.rows) {
        const targetQuestionId = questionMapping[option.question_id];
        
        if (targetQuestionId) {
          await pool.query(`
            UPDATE answer_options 
            SET question_id = $1, country = 'pt_BR'
            WHERE id = $2
          `, [targetQuestionId, option.id]);
          
          console.log(`✅ Opção ${option.id} movida da pergunta ${option.question_id} (en_US) para pergunta ${targetQuestionId} (pt_BR)`);
          console.log(`   Texto: "${option.option_text.substring(0, 60)}..."`);
        } else {
          console.log(`⚠️ Não foi possível encontrar pergunta equivalente em português para pergunta ${option.question_id}`);
        }
      }
    }
    
    // Fazer o mesmo para opções em espanhol, se houver
    console.log('\n🔍 Identificando opções em espanhol em perguntas inglesas...');
    const spanishInEnglish = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.country, q.country as question_country
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE q.country = 'en_US' 
      AND (ao.option_text ILIKE '%prefiero%' 
           OR ao.option_text ILIKE '%necesito%' 
           OR ao.option_text ILIKE '%trato%' 
           OR ao.option_text ILIKE '%veces%'
           OR ao.option_text ILIKE '%comunicación%'
           OR ao.option_text ILIKE '%confianza%'
           OR ao.option_text ILIKE '%crecimiento%'
           OR ao.option_text ILIKE '%experiencias%'
           OR ao.option_text ILIKE '%entender%'
           OR ao.option_text ILIKE '%perspectiva%')
      ORDER BY ao.question_id, ao.id
    `);
    
    console.log(`Encontradas ${spanishInEnglish.rows.length} opções em espanhol em perguntas inglesas`);
    
    // Reorganizar option_order para todas as perguntas afetadas
    console.log('\n🔄 Reorganizando ordem das opções...');
    const affectedQuestions = await pool.query(`
      SELECT DISTINCT question_id 
      FROM answer_options 
      WHERE question_id IN (
        SELECT id FROM questions WHERE country IN ('en_US', 'pt_BR', 'es_ES')
      )
      ORDER BY question_id
    `);
    
    for (const question of affectedQuestions.rows) {
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
    
    // Verificar se ainda há opções em idioma errado
    console.log('\n🔍 Verificando se ainda há opções em idioma errado...');
    const stillMixed = await pool.query(`
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
           OR ao.option_text ILIKE '%crescimento%')
    `);
    
    if (stillMixed.rows[0].count > 0) {
      console.log(`⚠️ Ainda há ${stillMixed.rows[0].count} opções em português em perguntas inglesas`);
    } else {
      console.log('✅ Todas as opções estão nos idiomas corretos');
    }
    
    // Mostrar exemplo de opções por idioma
    console.log('\n📝 Exemplo de opções por idioma:');
    
    const sampleByLanguage = await pool.query(`
      SELECT q.country, ao.option_text
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      WHERE ao.question_id IN (1, 2, 3)
      ORDER BY q.country, ao.question_id, ao.option_order
      LIMIT 6
    `);
    
    sampleByLanguage.rows.forEach(row => {
      console.log(`  ${row.country}: "${row.option_text.substring(0, 50)}..."`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function main() {
  console.log('🚀 Iniciando correção de opções com idiomas misturados...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await fixMixedLanguageOptionsPostgreSQL();
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