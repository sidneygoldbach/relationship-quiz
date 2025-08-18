const { pool, dbType } = require('./database');

async function standardizeOptionsCount() {
  try {
    console.log('🔧 Padronizando número de opções para 4 em todas as perguntas...');
    
    if (dbType === 'postgresql') {
      // Verificar situação atual
      console.log('\n📊 Situação atual das opções:');
      const currentStatus = await pool.query(`
        SELECT ao.question_id, q.question_text, COUNT(*) as options_count
        FROM answer_options ao
        JOIN questions q ON ao.question_id = q.id
        WHERE q.country = 'pt_BR'
        GROUP BY ao.question_id, q.question_text
        ORDER BY ao.question_id
      `);
      
      currentStatus.rows.forEach(row => {
        console.log(`Pergunta ${row.question_id}: ${row.options_count} opções - "${row.question_text.substring(0, 50)}..."`);
      });
      
      // Pergunta 18: Adicionar uma opção (tem 3, precisa de 4)
      console.log('\n🔧 Corrigindo pergunta 18 (Como você lida com conflitos)...');
      const question18Options = await pool.query(`
        SELECT * FROM answer_options 
        WHERE question_id = 18 AND country = 'pt_BR'
        ORDER BY option_order
      `);
      
      if (question18Options.rows.length === 3) {
        // Adicionar a quarta opção que estava faltando
        const newOption = {
          text: "Preciso de tempo para processar antes de discutir o problema.",
          weight: JSON.stringify({
            "Analítico": 3,
            "Diplomático": 2,
            "Sentinela": 1,
            "Explorador": 0
          })
        };
        
        await pool.query(`
          INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country, created_at)
          VALUES ($1, $2, $3, $4, $5, NOW())
        `, [18, newOption.text, 4, newOption.weight, 'pt_BR']);
        
        console.log('✅ Adicionada opção faltante na pergunta 18');
      }
      
      // Pergunta 20: Remover uma opção (tem 5, precisa de 4)
      console.log('\n🔧 Corrigindo pergunta 20 (O que é mais importante)...');
      const question20Options = await pool.query(`
        SELECT * FROM answer_options 
        WHERE question_id = 20 AND country = 'pt_BR'
        ORDER BY option_order
      `);
      
      if (question20Options.rows.length === 5) {
        // Remover a opção "Assumir a liderança" que não se encaixa bem na pergunta
        await pool.query(`
          DELETE FROM answer_options 
          WHERE question_id = 20 
          AND country = 'pt_BR' 
          AND option_text ILIKE '%assumir a liderança%'
        `);
        
        console.log('✅ Removida opção inadequada da pergunta 20');
      }
      
      // Pergunta 22: Remover uma opção (tem 5, precisa de 4)
      console.log('\n🔧 Corrigindo pergunta 22 (Como você expressa amor)...');
      const question22Options = await pool.query(`
        SELECT * FROM answer_options 
        WHERE question_id = 22 AND country = 'pt_BR'
        ORDER BY option_order
      `);
      
      if (question22Options.rows.length === 5) {
        // Remover a primeira opção para manter as 4 mais relevantes
        const firstOption = question22Options.rows[0];
        await pool.query(`
          DELETE FROM answer_options 
          WHERE id = $1
        `, [firstOption.id]);
        
        console.log(`✅ Removida primeira opção da pergunta 22: "${firstOption.option_text}"`);
      }
      
      // Verificação final
      console.log('\n📊 Situação após correções:');
      const finalStatus = await pool.query(`
        SELECT ao.question_id, q.question_text, COUNT(*) as options_count
        FROM answer_options ao
        JOIN questions q ON ao.question_id = q.id
        WHERE q.country = 'pt_BR'
        GROUP BY ao.question_id, q.question_text
        ORDER BY ao.question_id
      `);
      
      let allCorrect = true;
      finalStatus.rows.forEach(row => {
        const status = row.options_count === 4 ? '✅' : '❌';
        console.log(`${status} Pergunta ${row.question_id}: ${row.options_count} opções - "${row.question_text.substring(0, 50)}..."`);
        if (row.options_count !== 4) allCorrect = false;
      });
      
      if (allCorrect) {
        console.log('\n🎉 Todas as perguntas agora têm exatamente 4 opções!');
      } else {
        console.log('\n⚠️ Algumas perguntas ainda não têm 4 opções.');
      }
      
    } else {
      console.log('❌ Este script é apenas para PostgreSQL');
    }
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    if (dbType === 'postgresql') {
      await pool.end();
    }
  }
}

standardizeOptionsCount();