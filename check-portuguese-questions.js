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

async function checkPortugueseQuestions() {
  console.log('🇧🇷 VERIFICANDO PERGUNTAS EM PORTUGUÊS');
  console.log('====================================');
  
  try {
    // 1. Verificar total de perguntas por idioma
    console.log('\n1. 📊 Total de perguntas por idioma:');
    
    const countByCountry = await pool.query(`
      SELECT country, COUNT(*) as total
      FROM questions 
      WHERE is_active = true
      GROUP BY country
      ORDER BY country
    `);
    
    countByCountry.rows.forEach(row => {
      console.log(`   ${row.country}: ${row.total} perguntas`);
    });
    
    // 2. Verificar se pergunta 24 existe em português
    console.log('\n2. 🔍 Verificando pergunta 24 em português:');
    
    const q24Portuguese = await pool.query(
      'SELECT id, question_text, country, question_order FROM questions WHERE id = 24 AND country = $1',
      ['pt_BR']
    );
    
    if (q24Portuguese.rows.length > 0) {
      const q = q24Portuguese.rows[0];
      console.log('   ✅ Pergunta 24 encontrada em português!');
      console.log(`   Texto: "${q.question_text}"`);
      console.log(`   Ordem: ${q.question_order}`);
    } else {
      console.log('   ❌ Pergunta 24 NÃO encontrada em português!');
    }
    
    // 3. Listar todas as perguntas em português por ordem
    console.log('\n3. 📝 Perguntas em português (por ordem):');
    
    const portugueseQuestions = await pool.query(`
      SELECT id, question_text, question_order
      FROM questions 
      WHERE country = 'pt_BR' AND is_active = true
      ORDER BY question_order, id
    `);
    
    portugueseQuestions.rows.forEach((q, index) => {
      console.log(`   ${index + 1}. ID ${q.id} (ordem ${q.question_order}): "${q.question_text.substring(0, 50)}..."`);
    });
    
    // 4. Verificar qual é a última pergunta em português
    console.log('\n4. 🎯 Última pergunta em português:');
    
    const lastPortugueseQuestion = await pool.query(`
      SELECT id, question_text, question_order
      FROM questions 
      WHERE country = 'pt_BR' AND is_active = true
      ORDER BY question_order DESC, id DESC
      LIMIT 1
    `);
    
    if (lastPortugueseQuestion.rows.length > 0) {
      const lastQ = lastPortugueseQuestion.rows[0];
      console.log(`   ID: ${lastQ.id}`);
      console.log(`   Ordem: ${lastQ.question_order}`);
      console.log(`   Texto: "${lastQ.question_text}"`);
    }
    
    // 5. Comparar com inglês
    console.log('\n5. 🔄 Comparando com inglês:');
    
    const englishQuestions = await pool.query(`
      SELECT id, question_text, question_order
      FROM questions 
      WHERE country = 'en_US' AND is_active = true
      ORDER BY question_order, id
    `);
    
    console.log(`   Inglês: ${englishQuestions.rows.length} perguntas`);
    console.log(`   Português: ${portugueseQuestions.rows.length} perguntas`);
    
    if (englishQuestions.rows.length !== portugueseQuestions.rows.length) {
      console.log('   ⚠️  INCONSISTÊNCIA: Número diferente de perguntas!');
      
      // Verificar quais perguntas estão faltando
      const englishOrders = englishQuestions.rows.map(q => q.question_order);
      const portugueseOrders = portugueseQuestions.rows.map(q => q.question_order);
      
      const missingInPortuguese = englishOrders.filter(order => !portugueseOrders.includes(order));
      const extraInPortuguese = portugueseOrders.filter(order => !englishOrders.includes(order));
      
      if (missingInPortuguese.length > 0) {
        console.log(`   Ordens faltando em português: ${missingInPortuguese.join(', ')}`);
      }
      if (extraInPortuguese.length > 0) {
        console.log(`   Ordens extras em português: ${extraInPortuguese.join(', ')}`);
      }
    } else {
      console.log('   ✅ Mesmo número de perguntas em ambos idiomas');
    }
    
    // 6. Verificar se existe pergunta com ordem 5 em português
    console.log('\n6. 🔍 Verificando pergunta ordem 5 em português:');
    
    const order5Portuguese = await pool.query(`
      SELECT id, question_text, question_order
      FROM questions 
      WHERE country = 'pt_BR' AND question_order = 5 AND is_active = true
    `);
    
    if (order5Portuguese.rows.length > 0) {
      order5Portuguese.rows.forEach(q => {
        console.log(`   ID ${q.id}: "${q.question_text}"`);
      });
    } else {
      console.log('   ❌ Nenhuma pergunta com ordem 5 em português!');
    }
    
    console.log('\n====================================');
    console.log('🏁 VERIFICAÇÃO CONCLUÍDA');
    
  } catch (error) {
    console.error('❌ Erro durante verificação:', error);
  } finally {
    await pool.end();
  }
}

checkPortugueseQuestions();