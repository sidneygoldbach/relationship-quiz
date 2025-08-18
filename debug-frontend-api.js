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

async function debugFrontendAPI() {
  console.log('🔍 DEBUG: Verificando API do Frontend');
  console.log('=====================================');
  
  try {
    // 1. Simular chamada da API /api/questions
    console.log('\n1. 🌐 Simulando chamada /api/questions:');
    
    // Verificar perguntas por país/locale
    const locales = ['en_US', 'pt_BR', 'es_ES'];
    
    for (const locale of locales) {
      console.log(`\n📍 Locale: ${locale}`);
      
      // Simular a query que o frontend faz
      const questions = await pool.query(`
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
      `, [locale]);
      
      console.log(`   Total de perguntas: ${questions.rows.length}`);
      
      questions.rows.forEach((q, index) => {
        const optionsCount = q.options[0] ? q.options.length : 0;
        console.log(`   ${index + 1}. ID ${q.id} (ordem ${q.question_order}): "${q.question_text.substring(0, 40)}..." - ${optionsCount} opções`);
        
        // Verificar se é a pergunta 24
        if (q.id === 24) {
          console.log(`      🎯 PERGUNTA 24 ENCONTRADA!`);
          console.log(`      Opções:`);
          q.options.forEach((opt, i) => {
            console.log(`        ${i + 1}. "${opt.text}"`);
          });
        }
      });
    }
    
    // 2. Verificar se há perguntas com country 'US' (sem underscore)
    console.log('\n2. 🔍 Verificando perguntas com country="US":');
    const usQuestions = await pool.query(`
      SELECT q.id, q.question_text, q.country,
             json_agg(
               json_build_object(
                 'id', ao.id,
                 'text', ao.option_text,
                 'personality_weight', ao.personality_weight
               ) ORDER BY ao.option_order
             ) as options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      WHERE q.country = 'US' AND q.is_active = true
      GROUP BY q.id, q.question_text, q.country, q.question_order
      ORDER BY q.question_order
    `);
    
    console.log(`Perguntas com country='US': ${usQuestions.rows.length}`);
    usQuestions.rows.forEach(q => {
      const optionsCount = q.options[0] ? q.options.length : 0;
      console.log(`   ID ${q.id}: "${q.question_text.substring(0, 40)}..." - ${optionsCount} opções`);
    });
    
    // 3. Verificar a lógica de ordenação
    console.log('\n3. 📊 Verificando ordenação das perguntas:');
    const allActiveQuestions = await pool.query(`
      SELECT id, question_text, question_order, country
      FROM questions 
      WHERE is_active = true 
      ORDER BY question_order, id
    `);
    
    console.log('Todas as perguntas ativas (por ordem):');
    allActiveQuestions.rows.forEach((q, index) => {
      console.log(`   ${index + 1}. ID ${q.id} (ordem ${q.question_order}, country: ${q.country}): "${q.question_text.substring(0, 40)}..."`);
    });
    
    // 4. Verificar se há problema na query do servidor
    console.log('\n4. 🔧 Testando query exata do servidor:');
    
    // Esta é provavelmente a query que o server.js usa
    const serverQuery = await pool.query(`
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
      WHERE q.is_active = true
      GROUP BY q.id, q.question_text, q.question_order
      ORDER BY q.question_order
    `);
    
    console.log(`Query do servidor retorna: ${serverQuery.rows.length} perguntas`);
    
    const question24InServer = serverQuery.rows.find(q => q.id === 24);
    if (question24InServer) {
      console.log('✅ Pergunta 24 está na resposta do servidor!');
      console.log(`   Ordem: ${question24InServer.question_order}`);
      console.log(`   Opções: ${question24InServer.options.length}`);
    } else {
      console.log('❌ Pergunta 24 NÃO está na resposta do servidor!');
    }
    
    console.log('\n=====================================');
    console.log('🏁 DEBUG CONCLUÍDO');
    
  } catch (error) {
    console.error('❌ Erro no debug:', error.message);
    console.error('Stack:', error.stack);
  } finally {
    await pool.end();
  }
}

debugFrontendAPI();