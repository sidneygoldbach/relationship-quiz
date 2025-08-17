const { pool, dbType, initializeDatabase } = require('./database.js');

async function diagnoseKamateraOptions() {
  try {
    console.log('🔍 Diagnosticando problema das opções no Kamatera...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    // Verificar se existem opções para as perguntas
    console.log('\n📊 Verificando opções por pergunta:');
    
    if (dbType === 'postgresql') {
      // Verificar quantas opções existem por pergunta
      const optionsCount = await pool.query(`
        SELECT q.id as question_id, q.question_text, q.country, COUNT(o.id) as options_count
        FROM questions q
        LEFT JOIN options o ON q.id = o.question_id
        GROUP BY q.id, q.question_text, q.country
        ORDER BY q.id, q.country
      `);
      
      console.log('\nContagem de opções por pergunta:');
      optionsCount.rows.forEach(row => {
        console.log(`Pergunta ${row.question_id} (${row.country}): ${row.options_count} opções`);
        if (row.options_count === 0) {
          console.log(`⚠️  PROBLEMA: Pergunta ${row.question_id} (${row.country}) não tem opções!`);
        }
      });
      
      // Verificar se existem opções em português especificamente
      const ptOptions = await pool.query(`
        SELECT q.id as question_id, o.option_text, o.country
        FROM questions q
        JOIN options o ON q.id = o.question_id
        WHERE q.country = 'pt_BR' OR o.country = 'pt_BR'
        ORDER BY q.id
      `);
      
      console.log('\n🇧🇷 Opções em português encontradas:', ptOptions.rows.length);
      
      if (ptOptions.rows.length === 0) {
        console.log('❌ PROBLEMA IDENTIFICADO: Não há opções em português!');
        console.log('\n🔧 Executando correção...');
        
        // Executar script de adição de opções em português
        const { addPortugueseOptions } = require('./add-portuguese-options.js');
        await addPortugueseOptions();
        
        console.log('✅ Opções em português adicionadas!');
      } else {
        console.log('✅ Opções em português encontradas.');
        ptOptions.rows.slice(0, 5).forEach(row => {
          console.log(`  - Pergunta ${row.question_id}: ${row.option_text}`);
        });
      }
      
      // Verificar estrutura da tabela options
      const tableInfo = await pool.query(`
        SELECT column_name, data_type, is_nullable
        FROM information_schema.columns
        WHERE table_name = 'options'
        ORDER BY ordinal_position
      `);
      
      console.log('\n📋 Estrutura da tabela options:');
      tableInfo.rows.forEach(col => {
        console.log(`  - ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable})`);
      });
      
    } else {
      // SQLite
      await new Promise((resolve, reject) => {
        pool.all(`
          SELECT q.id as question_id, q.question_text, q.country, COUNT(o.id) as options_count
          FROM questions q
          LEFT JOIN options o ON q.id = o.question_id
          GROUP BY q.id, q.question_text, q.country
          ORDER BY q.id, q.country
        `, (err, rows) => {
          if (err) {
            reject(err);
            return;
          }
          
          console.log('\nContagem de opções por pergunta:');
          rows.forEach(row => {
            console.log(`Pergunta ${row.question_id} (${row.country}): ${row.options_count} opções`);
            if (row.options_count === 0) {
              console.log(`⚠️  PROBLEMA: Pergunta ${row.question_id} (${row.country}) não tem opções!`);
            }
          });
          
          resolve();
        });
      });
    }
    
    console.log('\n🎉 Diagnóstico concluído!');
    
  } catch (error) {
    console.error('❌ Erro no diagnóstico:', error);
    throw error;
  }
}

// Executar diagnóstico se chamado diretamente
if (require.main === module) {
  diagnoseKamateraOptions()
    .then(() => {
      console.log('🎉 Diagnóstico concluído!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Falha no diagnóstico:', error);
      process.exit(1);
    });
}

module.exports = { diagnoseKamateraOptions };