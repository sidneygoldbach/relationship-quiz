const { Pool } = require('pg');

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'quiz_app',
  user: 'quiz_user',
  password: 'quiz_password_2024'
});

async function checkAnswerWeights() {
  const client = await pool.connect();
  
  try {
    console.log('=== Portuguese answer options with weights ===');
    const ptResult = await client.query('SELECT id, option_text, personality_weight FROM answer_options WHERE country = $1 ORDER BY id LIMIT 10', ['pt_BR']);
    ptResult.rows.forEach(row => {
      console.log(`ID: ${row.id}, Text: ${row.option_text}, Weight: ${JSON.stringify(row.personality_weight)}`);
    });
    
    console.log('\n=== English answer options with weights (for comparison) ===');
    const enResult = await client.query('SELECT id, option_text, personality_weight FROM answer_options WHERE country = $1 ORDER BY id LIMIT 10', ['en_US']);
    enResult.rows.forEach(row => {
      console.log(`ID: ${row.id}, Text: ${row.option_text}, Weight: ${JSON.stringify(row.personality_weight)}`);
    });
    
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

checkAnswerWeights();