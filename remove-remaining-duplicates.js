const { pool, dbType } = require('./database');

async function removeRemainingDuplicatesPostgreSQL() {
  try {
    console.log('🗑️ Removendo opções duplicadas restantes...');
    
    // Identificar opções em português que ainda estão em perguntas inglesas
    console.log('\n🔍 Identificando opções em português restantes em perguntas inglesas...');
    const remainingPortuguese = await pool.query(`
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
           OR ao.option_text ILIKE '%perspectiva%'
           OR ao.option_text ILIKE '%abordar%'
           OR ao.option_text ILIKE '%processar%'
           OR ao.option_text ILIKE '%discutir%')
      ORDER BY ao.question_id, ao.id
    `);
    
    console.log(`Encontradas ${remainingPortuguese.rows.length} opções em português restantes`);
    
    if (remainingPortuguese.rows.length > 0) {
      console.log('\n📋 Opções que serão removidas:');
      remainingPortuguese.rows.forEach(option => {
        console.log(`  ID ${option.id} - Q${option.question_id}: "${option.option_text}"`);
      });
      
      // Verificar se existem versões equivalentes em inglês
      console.log('\n🔍 Verificando se existem versões equivalentes em inglês...');
      
      const translations = {
        'Prefiro abordar os problemas imediatamente e diretamente.': 'I prefer to address issues immediately and directly.',
        'Preciso de tempo para processar antes de discutir o problema.': 'I need time to process before discussing the problem.',
        'Tento encontrar um compromisso que funcione para todos.': 'I try to find a compromise that works for everyone.'
      };
      
      for (const option of remainingPortuguese.rows) {
        const englishVersion = translations[option.option_text];
        
        if (englishVersion) {
          // Verificar se a versão em inglês existe
          const englishExists = await pool.query(`
            SELECT id FROM answer_options 
            WHERE question_id = $1 AND option_text = $2
          `, [option.question_id, englishVersion]);
          
          if (englishExists.rows.length > 0) {
            console.log(`✅ Versão em inglês existe para: "${option.option_text}"`);
            console.log(`   Inglês: "${englishVersion}"`);
            
            // Remover a versão em português
            await pool.query(`DELETE FROM answer_options WHERE id = $1`, [option.id]);
            console.log(`🗑️ Removida opção duplicada ID ${option.id}`);
          } else {
            console.log(`⚠️ Versão em inglês não encontrada para: "${option.option_text}"`);
          }
        } else {
          console.log(`⚠️ Tradução não mapeada para: "${option.option_text}"`);
          // Remover mesmo assim, pois está no lugar errado
          await pool.query(`DELETE FROM answer_options WHERE id = $1`, [option.id]);
          console.log(`🗑️ Removida opção sem tradução mapeada ID ${option.id}`);
        }
      }
    }
    
    // Reorganizar option_order para todas as perguntas
    console.log('\n🔄 Reorganizando ordem das opções...');
    const allQuestions = await pool.query(`
      SELECT DISTINCT question_id 
      FROM answer_options 
      ORDER BY question_id
    `);
    
    for (const question of allQuestions.rows) {
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
    console.log('\n🔍 Verificação final de idiomas misturados...');
    const finalMixedCheck = await pool.query(`
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
    
    if (finalMixedCheck.rows[0].count > 0) {
      console.log(`⚠️ Ainda há ${finalMixedCheck.rows[0].count} opções em português em perguntas inglesas`);
      
      // Mostrar quais são
      const remaining = await pool.query(`
        SELECT ao.id, ao.question_id, ao.option_text
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
      
      remaining.rows.forEach(row => {
        console.log(`  ID ${row.id} - Q${row.question_id}: "${row.option_text}"`);
      });
    } else {
      console.log('✅ Todas as opções estão nos idiomas corretos!');
    }
    
    // Mostrar estatísticas por pergunta
    console.log('\n📊 Opções por pergunta (primeiras 10):');
    const optionsPerQuestion = await pool.query(`
      SELECT ao.question_id, q.country, COUNT(*) as total_options
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      GROUP BY ao.question_id, q.country
      ORDER BY ao.question_id
      LIMIT 10
    `);
    
    optionsPerQuestion.rows.forEach(row => {
      console.log(`  Pergunta ${row.question_id} (${row.country}): ${row.total_options} opções`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function main() {
  console.log('🚀 Iniciando remoção de duplicatas restantes...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await removeRemainingDuplicatesPostgreSQL();
    } else {
      console.log('📊 Usando SQLite - não implementado');
    }
    
    console.log('\n✅ Remoção concluída!');
  } catch (error) {
    console.error('❌ Erro durante a remoção:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };