const { Pool } = require('pg');

const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'quiz_app',
  user: 'quiz_user',
  password: 'quiz_password_2024'
});

async function addPortuguesePersonalityTypes() {
  const client = await pool.connect();
  
  try {
    const personalityTypes = [
      {
        key: 'The Communicator',
        pt_name: 'O Comunicador',
        pt_description: 'Você valoriza a comunicação aberta e honesta em relacionamentos. Você expressa seus sentimentos claramente e encoraja outros a fazerem o mesmo.'
      },
      {
        key: 'The Nurturer',
        pt_name: 'O Cuidador',
        pt_description: 'Você naturalmente cuida e apoia seu parceiro. Você encontra alegria em fazer outros se sentirem amados e seguros.'
      },
      {
        key: 'The Harmonizer',
        pt_name: 'O Harmonizador',
        pt_description: 'Você busca paz e equilíbrio em relacionamentos. Você trabalha para resolver conflitos e criar harmonia entre você e seu parceiro.'
      },
      {
        key: 'The Independent',
        pt_name: 'O Independente',
        pt_description: 'Você valoriza sua autonomia enquanto está em um relacionamento. Você acredita que parceiros saudáveis mantêm suas identidades individuais.'
      },
      {
        key: 'The Loyalist',
        pt_name: 'O Leal',
        pt_description: 'Você é profundamente comprometido e leal em relacionamentos. Você valoriza estabilidade e constrói conexões duradouras.'
      }
    ];

    for (const type of personalityTypes) {
      await client.query(
        'INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES ($1, $2, $3, $4, $5)',
        [1, type.pt_name, type.key, type.pt_description, 'pt_BR']
      );
    }
    
    console.log('✅ Portuguese personality types added successfully');
    
  } catch (error) {
    console.error('❌ Error adding Portuguese personality types:', error);
  } finally {
    client.release();
    await pool.end();
  }
}

addPortuguesePersonalityTypes();