const { Pool } = require('pg');

// Usar as mesmas credenciais do sistema existente
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'quiz_app',
  user: process.env.DB_USER || 'quiz_user',
  password: process.env.DB_PASSWORD || 'quiz_password_2024'
});

async function fixQuestion24Options() {
  const client = await pool.connect();
  
  try {
    console.log('🔍 Verificando estrutura das tabelas...');
    
    // Verificar estrutura da tabela questions
    const questionsSchema = await client.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'questions' 
      ORDER BY ordinal_position
    `);
    
    console.log('📋 Estrutura da tabela questions:');
    questionsSchema.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type}`);
    });
    
    // Verificar estrutura da tabela answer_options
    const optionsSchema = await client.query(`
      SELECT column_name, data_type 
      FROM information_schema.columns 
      WHERE table_name = 'answer_options' 
      ORDER BY ordinal_position
    `);
    
    console.log('📋 Estrutura da tabela answer_options:');
    optionsSchema.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type}`);
    });
    
    // Verificar se existe pergunta com ID 24
    const questionResult = await client.query(
      'SELECT * FROM questions WHERE id = 24'
    );
    
    if (questionResult.rows.length === 0) {
      console.log('❌ Pergunta 24 não encontrada!');
      return;
    }
    
    console.log('✅ Pergunta 24 encontrada:');
    console.log(questionResult.rows[0]);
    
    // Verificar opções existentes para pergunta 24
    const existingOptions = await client.query(
      'SELECT * FROM answer_options WHERE question_id = 24 ORDER BY id'
    );
    
    console.log(`📊 Opções existentes para pergunta 24: ${existingOptions.rows.length}`);
    existingOptions.rows.forEach(option => {
      console.log(`  - ID ${option.id}: ${option.option_text || option.text || 'N/A'}`);
    });
    
    // Se já tem 4 ou mais opções, não precisa fazer nada
    if (existingOptions.rows.length >= 4) {
      console.log('✅ Pergunta 24 já tem opções suficientes!');
      return;
    }
    
    // Deletar opções existentes para evitar duplicatas
    if (existingOptions.rows.length > 0) {
      console.log('🗑️ Removendo opções existentes...');
      await client.query('DELETE FROM answer_options WHERE question_id = 24');
    }
    
    // Adicionar as 4 opções corretas
    console.log('➕ Adicionando opções para pergunta 24...');
    
    const options = [
      { text: 'Physical appearance', weight: 1 },
      { text: 'Sense of humor', weight: 2 },
      { text: 'Intelligence', weight: 3 },
      { text: 'Kindness', weight: 4 }
    ];
    
    for (let i = 0; i < options.length; i++) {
      const option = options[i];
      
      // Tentar diferentes nomes de colunas baseado na estrutura real
      try {
        // Primeiro, tentar com option_text
        await client.query(
          'INSERT INTO answer_options (question_id, option_text, weight) VALUES ($1, $2, $3)',
          [24, option.text, option.weight]
        );
        console.log(`  ✅ Adicionada: ${option.text}`);
      } catch (error1) {
        try {
          // Se falhar, tentar com text
          await client.query(
            'INSERT INTO answer_options (question_id, text, weight) VALUES ($1, $2, $3)',
            [24, option.text, option.weight]
          );
          console.log(`  ✅ Adicionada: ${option.text}`);
        } catch (error2) {
          try {
            // Se falhar, tentar sem weight
            await client.query(
              'INSERT INTO answer_options (question_id, option_text) VALUES ($1, $2)',
              [24, option.text]
            );
            console.log(`  ✅ Adicionada (sem weight): ${option.text}`);
          } catch (error3) {
            try {
              // Última tentativa com text sem weight
              await client.query(
                'INSERT INTO answer_options (question_id, text) VALUES ($1, $2)',
                [24, option.text]
              );
              console.log(`  ✅ Adicionada (text sem weight): ${option.text}`);
            } catch (error4) {
              console.log(`  ❌ Erro ao adicionar ${option.text}:`, error4.message);
            }
          }
        }
      }
    }
    
    // Verificar resultado final
    const finalOptions = await client.query(
      'SELECT * FROM answer_options WHERE question_id = 24 ORDER BY id'
    );
    
    console.log(`\n🎉 Resultado final: ${finalOptions.rows.length} opções para pergunta 24`);
    finalOptions.rows.forEach(option => {
      console.log(`  - ID ${option.id}: ${option.option_text || option.text || 'N/A'}`);
    });
    
  } catch (error) {
    console.error('❌ Erro ao corrigir pergunta 24:', error.message);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    console.log('🚀 Iniciando correção da pergunta 24 (compatível com Kamatera)...');
    await fixQuestion24Options();
    console.log('✅ Correção concluída!');
  } catch (error) {
    console.error('❌ Erro na execução:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

if (require.main === module) {
  main();
}

module.exports = { fixQuestion24Options };