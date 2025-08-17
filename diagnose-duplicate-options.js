const { pool, dbType } = require('./database');

async function diagnoseDuplicateOptionsPostgreSQL() {
  try {
    console.log('🔍 Verificando opções duplicadas no PostgreSQL...');
    
    // Verificar estrutura da tabela answer_options
    console.log('\n📋 Estrutura da tabela answer_options:');
    const structure = await pool.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'answer_options' 
      ORDER BY ordinal_position
    `);
    
    structure.rows.forEach(row => {
      console.log(`  ${row.column_name}: ${row.data_type} (nullable: ${row.is_nullable})`);
    });
    
    // Contar total de opções por pergunta
    console.log('\n📊 Total de opções por pergunta:');
    const optionsPerQuestion = await pool.query(`
      SELECT question_id, COUNT(*) as total_options
      FROM answer_options 
      GROUP BY question_id 
      ORDER BY question_id
    `);
    
    optionsPerQuestion.rows.forEach(row => {
      console.log(`  Pergunta ${row.question_id}: ${row.total_options} opções`);
    });
    
    // Verificar opções duplicadas (mesmo texto para mesma pergunta)
    console.log('\n🔍 Verificando opções com texto duplicado:');
    const duplicateOptions = await pool.query(`
      SELECT question_id, option_text, COUNT(*) as count
      FROM answer_options 
      GROUP BY question_id, option_text 
      HAVING COUNT(*) > 1
      ORDER BY question_id, count DESC
    `);
    
    if (duplicateOptions.rows.length === 0) {
      console.log('  ✅ Nenhuma opção com texto duplicado encontrada');
    } else {
      console.log('  ❌ Opções com texto duplicado encontradas:');
      duplicateOptions.rows.forEach(row => {
        console.log(`    Pergunta ${row.question_id}: "${row.option_text}" (${row.count} vezes)`);
      });
    }
    
    // Verificar opções por locale/país
    console.log('\n🌍 Opções por locale (via join com questions):');
    const optionsByLocale = await pool.query(`
      SELECT q.country, COUNT(ao.*) as total_options
      FROM questions q
      LEFT JOIN answer_options ao ON q.id = ao.question_id
      GROUP BY q.country
      ORDER BY q.country
    `);
    
    optionsByLocale.rows.forEach(row => {
      console.log(`  ${row.country}: ${row.total_options} opções`);
    });
    
    // Verificar se há opções órfãs (sem pergunta correspondente)
    console.log('\n🔍 Verificando opções órfãs:');
    const orphanOptions = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text
      FROM answer_options ao
      LEFT JOIN questions q ON ao.question_id = q.id
      WHERE q.id IS NULL
    `);
    
    if (orphanOptions.rows.length === 0) {
      console.log('  ✅ Nenhuma opção órfã encontrada');
    } else {
      console.log('  ❌ Opções órfãs encontradas:');
      orphanOptions.rows.forEach(row => {
        console.log(`    ID ${row.id}: Pergunta ${row.question_id} - "${row.option_text}"`);
      });
    }
    
    // Mostrar algumas opções de exemplo
    console.log('\n📝 Exemplo de opções (primeiras 10):');
    const sampleOptions = await pool.query(`
      SELECT ao.id, ao.question_id, ao.option_text, ao.option_order, q.country
      FROM answer_options ao
      JOIN questions q ON ao.question_id = q.id
      ORDER BY ao.question_id, ao.option_order
      LIMIT 10
    `);
    
    sampleOptions.rows.forEach(row => {
      console.log(`  Q${row.question_id} (${row.country}) - Ordem ${row.option_order}: "${row.option_text}"`);
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.message);
  } finally {
    await pool.end();
  }
}

async function diagnoseDuplicateOptionsSQLite() {
  return new Promise((resolve, reject) => {
    console.log('🔍 Verificando opções duplicadas no SQLite...');
    
    // Verificar estrutura da tabela quiz_options
    console.log('\n📋 Estrutura da tabela quiz_options:');
    pool.all("PRAGMA table_info(quiz_options)", (err, columns) => {
      if (err) {
        console.error('❌ Erro ao verificar estrutura:', err.message);
        return reject(err);
      }
      
      columns.forEach(col => {
        console.log(`  ${col.name}: ${col.type} (nullable: ${col.notnull === 0 ? 'YES' : 'NO'})`);
      });
      
      // Contar total de opções por pergunta
      console.log('\n📊 Total de opções por pergunta:');
      pool.all(`
        SELECT question_id, COUNT(*) as total_options
        FROM quiz_options 
        GROUP BY question_id 
        ORDER BY question_id
      `, (err, rows) => {
        if (err) {
          console.error('❌ Erro ao contar opções:', err.message);
          return reject(err);
        }
        
        rows.forEach(row => {
          console.log(`  Pergunta ${row.question_id}: ${row.total_options} opções`);
        });
        
        // Verificar opções duplicadas
        console.log('\n🔍 Verificando opções com texto duplicado:');
        pool.all(`
          SELECT question_id, option_text, COUNT(*) as count
          FROM quiz_options 
          GROUP BY question_id, option_text 
          HAVING COUNT(*) > 1
          ORDER BY question_id, count DESC
        `, (err, duplicates) => {
          if (err) {
            console.error('❌ Erro ao verificar duplicatas:', err.message);
            return reject(err);
          }
          
          if (duplicates.length === 0) {
            console.log('  ✅ Nenhuma opção com texto duplicado encontrada');
          } else {
            console.log('  ❌ Opções com texto duplicado encontradas:');
            duplicates.forEach(row => {
              console.log(`    Pergunta ${row.question_id}: "${row.option_text}" (${row.count} vezes)`);
            });
          }
          
          pool.close();
          resolve();
        });
      });
    });
  });
}

async function main() {
  console.log('🚀 Iniciando diagnóstico de opções duplicadas...');
  
  try {
    if (dbType === 'postgresql') {
      console.log('📊 Usando PostgreSQL');
      await diagnoseDuplicateOptionsPostgreSQL();
    } else {
      console.log('📊 Usando SQLite');
      await diagnoseDuplicateOptionsSQLite();
    }
    
    console.log('\n✅ Diagnóstico concluído!');
  } catch (error) {
    console.error('❌ Erro durante o diagnóstico:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };