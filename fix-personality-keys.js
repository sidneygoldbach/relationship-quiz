const { Pool } = require('pg');

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'quiz_app',
  user: 'quiz_user',
  password: 'quiz_password_2024'
});

async function fixPersonalityKeys() {
  const client = await pool.connect();
  
  try {
    // Mapping from old keys to new keys
    const keyMapping = {
      'The Communicator': 'communicator',
      'The Nurturer': 'nurturer',
      'The Harmonizer': 'harmonizer',
      'The Independent': 'independent',
      'The Loyalist': 'loyalist'
    };
    
    console.log('=== Updating personality type keys ===');
    
    for (const [oldKey, newKey] of Object.entries(keyMapping)) {
      // Update both English and Portuguese entries
      const result = await client.query(
        'UPDATE personality_types SET type_key = $1 WHERE type_key = $2',
        [newKey, oldKey]
      );
      console.log(`Updated ${result.rowCount} rows: ${oldKey} -> ${newKey}`);
    }
    
    console.log('\n=== Verifying updated keys ===');
    const verifyResult = await client.query('SELECT type_key, type_name, country FROM personality_types ORDER BY country, id');
    verifyResult.rows.forEach(row => {
      console.log(`${row.country}: ${row.type_key} (${row.type_name})`);
    });
    
  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

fixPersonalityKeys();