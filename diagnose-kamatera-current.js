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

async function diagnoseKamateraDatabase() {
  console.log('🔍 DIAGNÓSTICO COMPLETO DO BANCO KAMATERA');
  console.log('==========================================');
  
  try {
    // 1. Verificar conexão
    console.log('\n1. 🔌 Testando conexão...');
    await pool.query('SELECT NOW()');
    console.log('✅ Conexão OK');

    // 2. Verificar estrutura das tabelas
    console.log('\n2. 📊 Estrutura das tabelas:');
    
    // Verificar tabela questions
    const questionsStructure = await pool.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'questions' 
      ORDER BY ordinal_position
    `);
    console.log('\n📋 Tabela QUESTIONS:');
    questionsStructure.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
    });

    // Verificar tabela answer_options
    const optionsStructure = await pool.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'answer_options' 
      ORDER BY ordinal_position
    `);
    console.log('\n🎯 Tabela ANSWER_OPTIONS:');
    optionsStructure.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
    });

    // 3. Contar perguntas
    console.log('\n3. 📈 Contagem de perguntas:');
    const questionCount = await pool.query('SELECT COUNT(*) as total FROM questions');
    console.log(`Total de perguntas: ${questionCount.rows[0].total}`);

    // 4. Listar todas as perguntas
    console.log('\n4. 📝 Lista de todas as perguntas:');
    const allQuestions = await pool.query(`
      SELECT id, question_text, country
      FROM questions 
      ORDER BY id
    `);
    
    allQuestions.rows.forEach(q => {
      console.log(`  ID ${q.id}: "${q.question_text.substring(0, 50)}..." (country: ${q.country || 'null'})`);
    });

    // 5. Verificar especificamente a pergunta 24
    console.log('\n5. 🎯 Verificando pergunta 24:');
    const question24 = await pool.query('SELECT * FROM questions WHERE id = 24');
    
    if (question24.rows.length === 0) {
      console.log('❌ PERGUNTA 24 NÃO EXISTE!');
    } else {
      console.log('✅ Pergunta 24 encontrada:');
      console.log(`   Texto: "${question24.rows[0].question_text}"`);
      
      // Verificar opções da pergunta 24
      const options24 = await pool.query('SELECT * FROM answer_options WHERE question_id = 24 ORDER BY id');
      console.log(`   Opções: ${options24.rows.length}`);
      
      options24.rows.forEach((opt, index) => {
        const optionText = opt.option_text || opt.text || 'NO_TEXT_COLUMN';
        console.log(`     ${index + 1}. "${optionText}"`);
      });
    }

    // 6. Verificar última pergunta (maior ID)
    console.log('\n6. 🔚 Verificando última pergunta:');
    const lastQuestion = await pool.query('SELECT * FROM questions ORDER BY id DESC LIMIT 1');
    
    if (lastQuestion.rows.length > 0) {
      const lastQ = lastQuestion.rows[0];
      console.log(`Última pergunta: ID ${lastQ.id}`);
      console.log(`Texto: "${lastQ.question_text}"`);
      
      // Verificar opções da última pergunta
      const lastOptions = await pool.query('SELECT * FROM answer_options WHERE question_id = $1 ORDER BY id', [lastQ.id]);
      console.log(`Opções da última pergunta: ${lastOptions.rows.length}`);
      
      lastOptions.rows.forEach((opt, index) => {
        const optionText = opt.option_text || opt.text || 'NO_TEXT_COLUMN';
        console.log(`  ${index + 1}. "${optionText}"`);
      });
    }

    // 7. Verificar se existe quiz_id e category_id para usar como referência
    console.log('\n7. 🔗 Verificando referências para criação:');
    const sampleQuestion = await pool.query('SELECT quiz_id, category_id FROM questions WHERE quiz_id IS NOT NULL AND category_id IS NOT NULL LIMIT 1');
    
    if (sampleQuestion.rows.length > 0) {
      console.log(`✅ Referência encontrada: quiz_id=${sampleQuestion.rows[0].quiz_id}, category_id=${sampleQuestion.rows[0].category_id}`);
    } else {
      console.log('⚠️  Nenhuma referência de quiz_id/category_id encontrada');
    }

    console.log('\n==========================================');
    console.log('🏁 DIAGNÓSTICO CONCLUÍDO');
    
  } catch (error) {
    console.error('❌ Erro no diagnóstico:', error.message);
    console.error('Stack:', error.stack);
  } finally {
    await pool.end();
  }
}

diagnoseKamateraDatabase();