const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'quiz_app',
  user: process.env.DB_USER || 'quiz_user',
  password: process.env.DB_PASSWORD || 'quiz_password_2024'
});

async function checkSpanishOptions() {
  try {
    console.log('Verificando opções em espanhol no banco de dados...');
    
    // Verificar se a tabela existe
    const tableCheck = await pool.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_name LIKE '%option%'
    `);
    
    console.log('Tabelas relacionadas a opções:', tableCheck.rows.map(r => r.table_name));
    
    // Tentar diferentes nomes de tabela
    const possibleTables = ['quiz_options', 'options', 'question_options'];
    
    for (const tableName of possibleTables) {
      try {
        const result = await pool.query(`
          SELECT question_number, option_number, option_text, locale 
          FROM ${tableName} 
          WHERE locale = 'es_ES' 
          ORDER BY question_number, option_number
        `);
        
        console.log(`\n=== Opções em espanhol na tabela ${tableName} ===`);
        if (result.rows.length === 0) {
          console.log('Nenhuma opção em espanhol encontrada!');
        } else {
          result.rows.forEach(row => {
            console.log(`Q${row.question_number} Opção ${row.option_number}: ${row.option_text}`);
          });
        }
        break;
      } catch (err) {
        console.log(`Tabela ${tableName} não existe ou erro:`, err.message);
      }
    }
    
  } catch (error) {
    console.error('Erro geral:', error);
  } finally {
    await pool.end();
  }
}

checkSpanishOptions();