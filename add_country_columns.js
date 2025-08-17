const { pool, dbType } = require('./database.js');

async function addCountryColumns() {
  try {
    console.log('🔄 Adicionando colunas country às tabelas existentes...');
    
    if (dbType === 'postgresql') {
      // PostgreSQL
      await pool.query('ALTER TABLE questions ADD COLUMN IF NOT EXISTS country VARCHAR(5) DEFAULT \'en_US\'');
      await pool.query('ALTER TABLE answer_options ADD COLUMN IF NOT EXISTS country VARCHAR(5) DEFAULT \'en_US\'');
      await pool.query('ALTER TABLE personality_types ADD COLUMN IF NOT EXISTS country VARCHAR(5) DEFAULT \'en_US\'');
      await pool.query('ALTER TABLE advice ADD COLUMN IF NOT EXISTS country VARCHAR(5) DEFAULT \'en_US\'');
      
      console.log('✅ Colunas country adicionadas com sucesso no PostgreSQL!');
    } else {
      // SQLite
      await new Promise((resolve, reject) => {
        pool.serialize(() => {
          pool.run('ALTER TABLE questions ADD COLUMN country VARCHAR(5) DEFAULT \'en_US\'', (err) => {
            if (err && !err.message.includes('duplicate column name')) {
              console.error('Erro ao adicionar coluna country em questions:', err.message);
            }
          });
          
          pool.run('ALTER TABLE answer_options ADD COLUMN country VARCHAR(5) DEFAULT \'en_US\'', (err) => {
            if (err && !err.message.includes('duplicate column name')) {
              console.error('Erro ao adicionar coluna country em answer_options:', err.message);
            }
          });
          
          pool.run('ALTER TABLE personality_types ADD COLUMN country VARCHAR(5) DEFAULT \'en_US\'', (err) => {
            if (err && !err.message.includes('duplicate column name')) {
              console.error('Erro ao adicionar coluna country em personality_types:', err.message);
            }
          });
          
          pool.run('ALTER TABLE advice ADD COLUMN country VARCHAR(5) DEFAULT \'en_US\'', (err) => {
            if (err && !err.message.includes('duplicate column name')) {
              console.error('Erro ao adicionar coluna country em advice:', err.message);
            }
            resolve();
          });
        });
      });
      
      console.log('✅ Colunas country adicionadas com sucesso no SQLite!');
    }
    
  } catch (error) {
    console.error('❌ Erro ao adicionar colunas:', error.message);
    throw error;
  }
}

// Executar se chamado diretamente
if (require.main === module) {
  addCountryColumns()
    .then(() => {
      console.log('🎉 Colunas adicionadas com sucesso!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Falha ao adicionar colunas:', error);
      process.exit(1);
    });
}

module.exports = { addCountryColumns };