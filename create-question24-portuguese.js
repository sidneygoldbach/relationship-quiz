#!/usr/bin/env node

const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 5432,
});

async function createQuestion24Portuguese() {
  console.log('🇧🇷 CRIANDO PERGUNTA 24 EM PORTUGUÊS');
  console.log('===================================');
  
  try {
    // 1. Verificar se pergunta 24 já existe em português
    console.log('\n1. 🔍 Verificando se pergunta 24 já existe em português:');
    
    const existingQ24 = await pool.query(
      'SELECT id FROM questions WHERE id = 24 AND country = $1',
      ['pt_BR']
    );
    
    if (existingQ24.rows.length > 0) {
      console.log('   ✅ Pergunta 24 já existe em português!');
      return;
    }
    
    console.log('   ❌ Pergunta 24 não existe em português. Criando...');
    
    // 2. Buscar pergunta 24 em inglês como referência
    console.log('\n2. 📖 Buscando pergunta 24 em inglês como referência:');
    
    const englishQ24 = await pool.query(
      'SELECT * FROM questions WHERE id = 24 AND country = $1',
      ['en_US']
    );
    
    if (englishQ24.rows.length === 0) {
      console.log('   ❌ Pergunta 24 não encontrada em inglês!');
      return;
    }
    
    const refQuestion = englishQ24.rows[0];
    console.log(`   Pergunta em inglês: "${refQuestion.question_text}"`);
    console.log(`   Ordem: ${refQuestion.question_order}`);
    
    // 3. Criar pergunta 24 em português
    console.log('\n3. ✨ Criando pergunta 24 em português:');
    
    const questionTextPt = "O que mais te atrai em uma pessoa?";
    
    // Inserir pergunta sem usar ON CONFLICT
    const insertQuestion = await pool.query(`
      INSERT INTO questions (quiz_id, category_id, question_text, question_order, country, is_active)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `, [refQuestion.quiz_id, refQuestion.category_id, questionTextPt, refQuestion.question_order, 'pt_BR', true]);
    
    console.log('   ✅ Pergunta 24 criada em português!');
    console.log(`   ID: ${insertQuestion.rows[0].id}`);
    console.log(`   Texto: "${insertQuestion.rows[0].question_text}"`);
    
    const newQuestionId = insertQuestion.rows[0].id;
    
    // 4. Buscar opções da pergunta 24 em inglês
    console.log('\n4. 📋 Buscando opções da pergunta 24 em inglês:');
    
    const englishOptions = await pool.query(
      'SELECT * FROM answer_options WHERE question_id = 24 ORDER BY option_order'
    );
    
    console.log(`   Encontradas ${englishOptions.rows.length} opções em inglês`);
    
    // 5. Criar opções em português
    console.log('\n5. ✨ Criando opções em português:');
    
    const portugueseOptions = [
      "Inteligência e senso de humor",
      "Aparência física e estilo", 
      "Bondade e compaixão",
      "Ambição e determinação"
    ];
    
    for (let i = 0; i < englishOptions.rows.length && i < portugueseOptions.length; i++) {
      const englishOption = englishOptions.rows[i];
      const portugueseText = portugueseOptions[i];
      
      const insertOption = await pool.query(`
        INSERT INTO answer_options (question_id, option_text, option_order, personality_weight)
        VALUES ($1, $2, $3, $4)
        RETURNING *
      `, [newQuestionId, portugueseText, englishOption.option_order, englishOption.personality_weight]);
      
      console.log(`   ✅ Opção ${i + 1}: "${portugueseText}"`);
    }
    
    // 6. Verificação final
    console.log('\n6. ✅ Verificação final:');
    
    const finalCheck = await pool.query(`
      SELECT q.id, q.question_text, q.question_order,
             json_agg(
               json_build_object(
                 'id', ao.id,
                 'text', ao.option_text,
                 'order', ao.option_order
               ) ORDER BY ao.option_order
             ) as options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      WHERE q.id = $1 AND q.country = 'pt_BR'
      GROUP BY q.id, q.question_text, q.question_order
    `, [newQuestionId]);
    
    if (finalCheck.rows.length > 0) {
      const q = finalCheck.rows[0];
      console.log(`   Pergunta ID ${q.id}: "${q.question_text}"`);
      console.log(`   Ordem: ${q.question_order}`);
      console.log(`   Opções: ${q.options.length}`);
      q.options.forEach((opt, idx) => {
        console.log(`     ${idx + 1}. "${opt.text}"`);
      });
    }
    
    // 7. Verificar total de perguntas em português agora
    console.log('\n7. 📊 Total de perguntas em português após criação:');
    
    const totalPt = await pool.query(
      'SELECT COUNT(*) as total FROM questions WHERE country = $1 AND is_active = true',
      ['pt_BR']
    );
    
    console.log(`   Total: ${totalPt.rows[0].total} perguntas`);
    
    console.log('\n===================================');
    console.log('🏁 PERGUNTA 24 CRIADA COM SUCESSO!');
    
  } catch (error) {
    console.error('❌ Erro durante criação:', error);
  } finally {
    await pool.end();
  }
}

createQuestion24Portuguese();