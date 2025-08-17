const { pool, dbType, initializeDatabase } = require('./database.js');

async function fixKamateraMigration() {
  try {
    console.log('🔧 Corrigindo migração do Kamatera...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    // Primeiro, verificar se existe um quiz com id=1
    let quizExists = false;
    
    if (dbType === 'postgresql') {
      const result = await pool.query('SELECT id FROM quizzes WHERE id = $1', [1]);
      quizExists = result.rows.length > 0;
    } else {
      await new Promise((resolve, reject) => {
        pool.get('SELECT id FROM quizzes WHERE id = ?', [1], (err, row) => {
          if (err) reject(err);
          else {
            quizExists = !!row;
            resolve();
          }
        });
      });
    }
    
    // Se não existe, criar o quiz padrão
    if (!quizExists) {
      console.log('📝 Criando quiz padrão...');
      
      if (dbType === 'postgresql') {
        await pool.query(
          'INSERT INTO quizzes (id, title, description, created_at) VALUES ($1, $2, $3, $4)',
          [1, 'Relationship Personality Quiz', 'Discover your relationship personality type', new Date()]
        );
      } else {
        await new Promise((resolve, reject) => {
          pool.run(
            'INSERT INTO quizzes (id, title, description, created_at) VALUES (?, ?, ?, ?)',
            [1, 'Relationship Personality Quiz', 'Discover your relationship personality type', new Date().toISOString()],
            (err) => {
              if (err) reject(err);
              else resolve();
            }
          );
        });
      }
      
      console.log('✅ Quiz padrão criado com sucesso!');
    } else {
      console.log('ℹ️  Quiz padrão já existe.');
    }
    
    // Agora executar a migração de traduções
    console.log('🔄 Executando migração de traduções...');
    const { migrateTranslations } = require('./migrate_translations.js');
    await migrateTranslations();
    
    console.log('🎉 Correção da migração concluída com sucesso!');
    
  } catch (error) {
    console.error('❌ Erro na correção da migração:', error);
    throw error;
  }
}

// Executar correção se chamado diretamente
if (require.main === module) {
  fixKamateraMigration()
    .then(() => {
      console.log('🎉 Correção concluída!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Falha na correção:', error);
      process.exit(1);
    });
}

module.exports = { fixKamateraMigration };