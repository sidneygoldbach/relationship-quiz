const { pool, dbType, initializeDatabase } = require('./database.js');

async function diagnoseKamateraAdvice() {
  try {
    console.log('🔍 Diagnosticando dados de advice no Kamatera...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    console.log('\n📊 Verificando tipos de personalidade...');
    
    if (dbType === 'postgresql') {
      // Verificar tipos de personalidade por locale
      const ptTypesResult = await pool.query(
        'SELECT id, type_name, type_key, country FROM personality_types WHERE quiz_id = $1 ORDER BY country, id',
        [1]
      );
      
      console.log('Tipos de personalidade encontrados:');
      ptTypesResult.rows.forEach(row => {
        console.log(`  ${row.country}: ${row.type_key} (${row.type_name}) - ID: ${row.id}`);
      });
      
      console.log('\n🎯 Verificando advice por tipo de personalidade e locale...');
      
      // Verificar advice para cada tipo
      for (const type of ptTypesResult.rows) {
        const adviceResult = await pool.query(
          'SELECT advice_type, advice_text, advice_order, country FROM advice WHERE personality_type_id = $1 ORDER BY advice_type, advice_order',
          [type.id]
        );
        
        console.log(`\n--- ${type.type_name} (${type.type_key}) - ${type.country} ---`);
        if (adviceResult.rows.length === 0) {
          console.log('  ❌ NENHUM ADVICE ENCONTRADO!');
        } else {
          const personalityAdvice = adviceResult.rows.filter(a => a.advice_type === 'personality');
          const relationshipAdvice = adviceResult.rows.filter(a => a.advice_type === 'relationship');
          
          console.log(`  Personality advice: ${personalityAdvice.length} itens`);
          personalityAdvice.forEach((advice, index) => {
            console.log(`    ${index + 1}. ${advice.advice_text.substring(0, 80)}...`);
          });
          
          console.log(`  Relationship advice: ${relationshipAdvice.length} itens`);
          relationshipAdvice.forEach((advice, index) => {
            console.log(`    ${index + 1}. ${advice.advice_text.substring(0, 80)}...`);
          });
        }
      }
      
      console.log('\n🔍 Verificando estrutura da tabela advice...');
      const tableStructure = await pool.query(
        "SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'advice' ORDER BY ordinal_position"
      );
      
      console.log('Estrutura da tabela advice:');
      tableStructure.rows.forEach(col => {
        console.log(`  ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable})`);
      });
      
      console.log('\n📈 Estatísticas gerais...');
      const statsResult = await pool.query(`
        SELECT 
          pt.country,
          COUNT(DISTINCT pt.id) as personality_types_count,
          COUNT(a.id) as total_advice_count,
          COUNT(CASE WHEN a.advice_type = 'personality' THEN 1 END) as personality_advice_count,
          COUNT(CASE WHEN a.advice_type = 'relationship' THEN 1 END) as relationship_advice_count
        FROM personality_types pt
        LEFT JOIN advice a ON pt.id = a.personality_type_id
        WHERE pt.quiz_id = $1
        GROUP BY pt.country
        ORDER BY pt.country
      `, [1]);
      
      console.log('Estatísticas por locale:');
      statsResult.rows.forEach(stat => {
        console.log(`  ${stat.country}:`);
        console.log(`    Tipos de personalidade: ${stat.personality_types_count}`);
        console.log(`    Total de advice: ${stat.total_advice_count}`);
        console.log(`    Personality advice: ${stat.personality_advice_count}`);
        console.log(`    Relationship advice: ${stat.relationship_advice_count}`);
      });
      
    } else {
      // SQLite version
      console.log('Usando SQLite - implementação similar...');
      
      await new Promise((resolve, reject) => {
        pool.all(
          'SELECT id, type_name, type_key, country FROM personality_types WHERE quiz_id = ? ORDER BY country, id',
          [1],
          (err, rows) => {
            if (err) {
              reject(err);
              return;
            }
            
            console.log('Tipos de personalidade encontrados:');
            rows.forEach(row => {
              console.log(`  ${row.country}: ${row.type_key} (${row.type_name}) - ID: ${row.id}`);
            });
            
            resolve();
          }
        );
      });
    }
    
    console.log('\n✅ Diagnóstico concluído!');
    
  } catch (error) {
    console.error('❌ Erro durante diagnóstico:', error);
  } finally {
    if (dbType === 'postgresql') {
      await pool.end();
    } else {
      pool.close();
    }
  }
}

diagnoseKamateraAdvice();