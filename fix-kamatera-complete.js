const { pool, dbType, initializeDatabase } = require('./database.js');

async function fixKamateraComplete() {
  try {
    console.log('🔧 Iniciando correção completa do Kamatera...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    // 1. Verificar e criar quiz padrão se necessário
    console.log('\n📝 Verificando quiz padrão...');
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
      
      console.log('✅ Quiz padrão criado!');
    } else {
      console.log('✅ Quiz padrão já existe.');
    }
    
    // 2. Executar script de adição de opções em português
    console.log('\n🇧🇷 Adicionando opções em português...');
    try {
      const { addPortugueseOptions } = require('./add-portuguese-options.js');
      await addPortugueseOptions();
      console.log('✅ Opções em português adicionadas!');
    } catch (error) {
      console.log('⚠️  Erro ao adicionar opções em português:', error.message);
      console.log('Continuando com próximos passos...');
    }
    
    // 3. Executar correção das chaves de personalidade
    console.log('\n🔑 Corrigindo chaves de personalidade...');
    try {
      const { fixPersonalityKeys } = require('./fix-personality-keys.js');
      await fixPersonalityKeys();
      console.log('✅ Chaves de personalidade corrigidas!');
    } catch (error) {
      console.log('⚠️  Erro ao corrigir chaves de personalidade:', error.message);
      console.log('Continuando com próximos passos...');
    }
    
    // 4. Executar adição de advice em português
    console.log('\n💡 Adicionando advice em português...');
    try {
      const { execSync } = require('child_process');
      execSync('node add-portuguese-advice.js', { stdio: 'inherit' });
      console.log('✅ Advice em português adicionado!');
    } catch (error) {
      console.log('⚠️  Erro ao adicionar advice em português:', error.message);
      console.log('Continuando com próximos passos...');
    }
    
    // 5. Executar migração de traduções
    console.log('\n🌐 Executando migração de traduções...');
    try {
      const { migrateTranslations } = require('./migrate_translations.js');
      await migrateTranslations();
      console.log('✅ Migração de traduções concluída!');
    } catch (error) {
      console.log('⚠️  Erro na migração de traduções:', error.message);
      console.log('Continuando com verificação final...');
    }
    
    // 5. Verificação final
    console.log('\n🔍 Verificação final...');
    
    if (dbType === 'postgresql') {
      // Verificar se existem opções para cada pergunta
      const optionsCheck = await pool.query(`
        SELECT q.id as question_id, q.country, COUNT(o.id) as options_count
        FROM questions q
        LEFT JOIN options o ON q.id = o.question_id AND q.country = o.country
        WHERE q.country = 'pt_BR'
        GROUP BY q.id, q.country
        ORDER BY q.id
      `);
      
      console.log('\n📊 Status das opções em português:');
      let allGood = true;
      
      optionsCheck.rows.forEach(row => {
        const status = row.options_count > 0 ? '✅' : '❌';
        console.log(`${status} Pergunta ${row.question_id}: ${row.options_count} opções`);
        if (row.options_count === 0) {
          allGood = false;
        }
      });
      
      if (allGood) {
        console.log('\n🎉 Todas as perguntas têm opções em português!');
      } else {
        console.log('\n⚠️  Algumas perguntas ainda não têm opções. Pode ser necessário executar manualmente:');
        console.log('node add-portuguese-options.js');
      }
      
      // Verificar tipos de personalidade
      const personalityCheck = await pool.query(`
        SELECT personality_type, country, COUNT(*) as count
        FROM personality_types
        WHERE country = 'pt_BR'
        GROUP BY personality_type, country
        ORDER BY personality_type
      `);
      
      console.log('\n🧠 Tipos de personalidade em português:');
      personalityCheck.rows.forEach(row => {
        console.log(`✅ ${row.personality_type}: ${row.count} registro(s)`);
      });
    }
    
    console.log('\n🎉 Correção completa do Kamatera finalizada!');
    console.log('\n📋 Próximos passos:');
    console.log('1. Reiniciar o servidor: pm2 restart all');
    console.log('2. Testar o quiz em português');
    console.log('3. Verificar se as opções aparecem corretamente');
    
  } catch (error) {
    console.error('❌ Erro na correção completa:', error);
    throw error;
  }
}

// Executar correção se chamado diretamente
if (require.main === module) {
  fixKamateraComplete()
    .then(() => {
      console.log('🎉 Correção completa concluída!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Falha na correção completa:', error);
      process.exit(1);
    });
}

module.exports = { fixKamateraComplete };