const { pool, dbType } = require('./database');

// Dados dos tipos de personalidade em espanhol
const spanishPersonalityTypes = [
  {
    type_key: 'communicator',
    type_name: 'El Comunicador',
    description: 'Valoras la comunicación abierta y honesta en las relaciones. Expresas tus sentimientos claramente y animas a otros a hacer lo mismo.'
  },
  {
    type_key: 'nurturer',
    type_name: 'El Cuidador',
    description: 'Priorizas el cuidado y apoyo de tu pareja. Eres naturalmente empático y te enfocas en las necesidades emocionales de otros.'
  },
  {
    type_key: 'harmonizer',
    type_name: 'El Armonizador',
    description: 'Buscas equilibrio y armonía en tus relaciones. Evitas conflictos y trabajas para crear un ambiente pacífico y comprensivo.'
  },
  {
    type_key: 'independent',
    type_name: 'El Independiente',
    description: 'Valoras tu autonomía personal mientras mantienes conexiones significativas. Equilibras el tiempo solo con la intimidad en las relaciones.'
  },
  {
    type_key: 'loyalist',
    type_name: 'El Leal',
    description: 'La lealtad y el compromiso son fundamentales para ti. Construyes relaciones duraderas basadas en la confianza y la consistencia.'
  }
];

async function addSpanishPersonalityTypesPostgreSQL() {
  try {
    console.log('🔍 Verificando tipos de personalidade existentes em espanhol...');
    
    // Verificar se já existem tipos em espanhol
    const existing = await pool.query(`
      SELECT COUNT(*) as count 
      FROM personality_types 
      WHERE country = 'es_ES'
    `);
    
    if (existing.rows[0].count > 0) {
      console.log(`✅ Já existem ${existing.rows[0].count} tipos de personalidade em espanhol`);
      return;
    }
    
    console.log('📝 Adicionando tipos de personalidade em espanhol...');
    
    for (const type of spanishPersonalityTypes) {
      await pool.query(`
        INSERT INTO personality_types (quiz_id, type_name, type_key, description, country)
        VALUES ($1, $2, $3, $4, 'es_ES')
      `, [1, type.type_name, type.type_key, type.description]);
      
      console.log(`✅ Adicionado: ${type.type_name} (${type.type_key})`);
    }
    
    // Verificar resultado final
    console.log('\n📊 Verificando resultado final...');
    const finalCount = await pool.query(`
      SELECT country, COUNT(*) as count 
      FROM personality_types 
      WHERE quiz_id = $1
      GROUP BY country 
      ORDER BY country
    `, [1]);
    
    finalCount.rows.forEach(row => {
      console.log(`${row.country}: ${row.count} tipos de personalidade`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function addSpanishPersonalityTypesSQLite() {
  return new Promise((resolve, reject) => {
    console.log('🔍 Verificando tipos de personalidade existentes em espanhol (SQLite)...');
    
    pool.get(`
      SELECT COUNT(*) as count 
      FROM personality_types 
      WHERE country = 'es_ES'
    `, (err, result) => {
      if (err) {
        console.error('❌ Erro ao verificar tipos existentes:', err.message);
        return reject(err);
      }
      
      if (result.count > 0) {
        console.log(`✅ Já existem ${result.count} tipos de personalidade em espanhol`);
        pool.close();
        return resolve();
      }
      
      console.log('📝 Adicionando tipos de personalidade em espanhol...');
      
      const stmt = pool.prepare(`
        INSERT INTO personality_types (quiz_id, type_name, type_key, description, country)
        VALUES (?, ?, ?, ?, 'es_ES')
      `);
      
      let completed = 0;
      const total = spanishPersonalityTypes.length;
      
      spanishPersonalityTypes.forEach(type => {
        stmt.run([1, type.type_name, type.type_key, type.description], (err) => {
          if (err) {
            console.error(`❌ Erro ao adicionar ${type.type_name}:`, err.message);
          } else {
            console.log(`✅ Adicionado: ${type.type_name} (${type.type_key})`);
          }
          
          completed++;
          if (completed === total) {
            stmt.finalize();
            
            // Verificar resultado final
            console.log('\n📊 Verificando resultado final...');
            pool.all(`
              SELECT country, COUNT(*) as count 
              FROM personality_types 
              WHERE quiz_id = ?
              GROUP BY country 
              ORDER BY country
            `, [1], (err, rows) => {
              if (err) {
                console.error('❌ Erro ao verificar resultado final:', err.message);
                return reject(err);
              }
              
              rows.forEach(row => {
                console.log(`${row.country}: ${row.count} tipos de personalidade`);
              });
              
              pool.close();
              resolve();
            });
          }
        });
      });
    });
  });
}

async function main() {
  console.log('🚀 Iniciando adição de tipos de personalidade em espanhol...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await addSpanishPersonalityTypesPostgreSQL();
    } else {
      console.log('📊 Usando SQLite');
      await addSpanishPersonalityTypesSQLite();
    }
    
    console.log('\n✅ Processo concluído com sucesso!');
  } catch (error) {
    console.error('❌ Erro durante o processo:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };