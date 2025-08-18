const { Pool } = require('pg');

// Configuração do banco PostgreSQL do Kamatera
const pool = new Pool({
  user: 'relationshipquiz',
  host: 'localhost',
  database: 'relationshipquiz',
  password: 'your_secure_password_here', // Substitua pela senha real
  port: 5432,
});

async function fixQuestion24Options() {
  const client = await pool.connect();
  
  try {
    console.log('🔍 Verificando pergunta 24 (en_US)...');
    
    // Verificar se a pergunta 24 existe
    const questionResult = await client.query(
      'SELECT id, question_text FROM questions WHERE id = 24 AND locale = $1',
      ['en_US']
    );
    
    if (questionResult.rows.length === 0) {
      console.log('❌ Pergunta 24 (en_US) não encontrada!');
      return;
    }
    
    console.log('✅ Pergunta encontrada:', questionResult.rows[0].question_text);
    
    // Verificar opções existentes
    const existingOptions = await client.query(
      'SELECT id, option_text FROM answer_options WHERE question_id = 24 ORDER BY id',
    );
    
    console.log(`📊 Opções existentes: ${existingOptions.rows.length}`);
    existingOptions.rows.forEach(option => {
      console.log(`  - ${option.id}: ${option.option_text}`);
    });
    
    // Se já tem 4 opções, não precisa fazer nada
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
    const options = [
      { text: 'Physical appearance', weight_extroversion: 0.2, weight_sensing: 0.3, weight_thinking: 0.1, weight_judging: 0.2 },
      { text: 'Sense of humor', weight_extroversion: 0.4, weight_sensing: 0.2, weight_thinking: 0.2, weight_judging: 0.1 },
      { text: 'Intelligence', weight_extroversion: 0.1, weight_sensing: 0.1, weight_thinking: 0.4, weight_judging: 0.3 },
      { text: 'Kindness and empathy', weight_extroversion: 0.3, weight_sensing: 0.4, weight_thinking: 0.3, weight_judging: 0.4 }
    ];
    
    console.log('➕ Adicionando 4 opções à pergunta 24...');
    
    for (let i = 0; i < options.length; i++) {
      const option = options[i];
      const result = await client.query(
        `INSERT INTO answer_options 
         (question_id, option_text, weight_extroversion, weight_sensing, weight_thinking, weight_judging) 
         VALUES ($1, $2, $3, $4, $5, $6) RETURNING id`,
        [24, option.text, option.weight_extroversion, option.weight_sensing, option.weight_thinking, option.weight_judging]
      );
      console.log(`  ✅ Opção ${i + 1} adicionada (ID: ${result.rows[0].id}): ${option.text}`);
    }
    
    // Verificação final
    const finalCheck = await client.query(
      'SELECT COUNT(*) as count FROM answer_options WHERE question_id = 24'
    );
    
    console.log(`\n🎉 Correção concluída! Pergunta 24 agora tem ${finalCheck.rows[0].count} opções.`);
    
  } catch (error) {
    console.error('❌ Erro ao corrigir pergunta 24:', error.message);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    console.log('🚀 Iniciando correção da pergunta 24 no Kamatera...');
    await fixQuestion24Options();
    console.log('✅ Script executado com sucesso!');
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