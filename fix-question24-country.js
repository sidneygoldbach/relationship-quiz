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

async function fixQuestion24Country() {
  console.log('🔧 CORRIGINDO COUNTRY DA PERGUNTA 24');
  console.log('===================================');
  
  try {
    // 1. Verificar estado atual da pergunta 24
    console.log('\n1. 🔍 Verificando estado atual da pergunta 24:');
    
    const currentQ24 = await pool.query(
      'SELECT id, question_text, country, question_order FROM questions WHERE id = 24'
    );
    
    if (currentQ24.rows.length === 0) {
      console.log('❌ Pergunta 24 não encontrada!');
      return;
    }
    
    const question = currentQ24.rows[0];
    console.log(`   ID: ${question.id}`);
    console.log(`   Country atual: '${question.country}'`);
    console.log(`   Ordem: ${question.question_order}`);
    console.log(`   Texto: "${question.question_text.substring(0, 50)}..."`);
    
    // 2. Verificar se precisa corrigir
    if (question.country === 'en_US') {
      console.log('\n✅ Pergunta 24 já tem country correto (en_US)!');
      return;
    }
    
    // 3. Corrigir o country
    console.log('\n2. 🔧 Corrigindo country de "US" para "en_US":');
    
    const updateResult = await pool.query(
      'UPDATE questions SET country = $1 WHERE id = 24',
      ['en_US']
    );
    
    console.log(`   ✅ ${updateResult.rowCount} linha(s) atualizada(s)`);
    
    // 4. Verificar correção
    console.log('\n3. ✅ Verificando correção:');
    
    const updatedQ24 = await pool.query(
      'SELECT id, question_text, country, question_order FROM questions WHERE id = 24'
    );
    
    const updatedQuestion = updatedQ24.rows[0];
    console.log(`   ID: ${updatedQuestion.id}`);
    console.log(`   Country corrigido: '${updatedQuestion.country}'`);
    console.log(`   Ordem: ${updatedQuestion.question_order}`);
    
    // 5. Verificar se agora aparece na query do frontend
    console.log('\n4. 🌐 Testando query do frontend para en_US:');
    
    const frontendQuery = await pool.query(`
      SELECT q.id, q.question_text, q.question_order,
             json_agg(
               json_build_object(
                 'id', ao.id,
                 'text', ao.option_text,
                 'personality_weight', ao.personality_weight
               ) ORDER BY ao.option_order
             ) as options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      WHERE q.country = $1 AND q.is_active = true
      GROUP BY q.id, q.question_text, q.question_order
      ORDER BY q.question_order
    `, ['en_US']);
    
    console.log(`   Total de perguntas en_US: ${frontendQuery.rows.length}`);
    
    const q24InFrontend = frontendQuery.rows.find(q => q.id === 24);
    if (q24InFrontend) {
      console.log('   ✅ Pergunta 24 agora aparece na query do frontend!');
      console.log(`   Ordem: ${q24InFrontend.question_order}`);
      console.log(`   Opções: ${q24InFrontend.options.length}`);
    } else {
      console.log('   ❌ Pergunta 24 ainda não aparece na query do frontend');
    }
    
    console.log('\n===================================');
    console.log('🏁 CORREÇÃO CONCLUÍDA');
    
  } catch (error) {
    console.error('❌ Erro durante correção:', error);
  } finally {
    await pool.end();
  }
}

fixQuestion24Country();