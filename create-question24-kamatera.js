const { Pool } = require('pg');

// Usar as mesmas credenciais do sistema existente
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'quiz_app',
  user: process.env.DB_USER || 'quiz_user',
  password: process.env.DB_PASSWORD || 'quiz_password_2024'
});

async function createQuestion24() {
  const client = await pool.connect();
  
  try {
    console.log('🔍 Analisando estrutura atual do quiz...');
    
    // Verificar quantas perguntas existem
    const questionsCount = await client.query(
      'SELECT COUNT(*) as total, MAX(id) as max_id FROM questions'
    );
    
    console.log(`📊 Total de perguntas: ${questionsCount.rows[0].total}`);
    console.log(`🔢 Maior ID: ${questionsCount.rows[0].max_id}`);
    
    // Listar todas as perguntas existentes
    const allQuestions = await client.query(
      'SELECT id, question_text, question_order FROM questions ORDER BY id'
    );
    
    console.log('📋 Perguntas existentes:');
    allQuestions.rows.forEach(q => {
      console.log(`  - ID ${q.id} (ordem ${q.question_order}): ${q.question_text.substring(0, 50)}...`);
    });
    
    // Verificar se pergunta 24 já existe
    const question24 = await client.query(
      'SELECT * FROM questions WHERE id = 24'
    );
    
    if (question24.rows.length > 0) {
      console.log('✅ Pergunta 24 já existe!');
      console.log(question24.rows[0]);
      
      // Verificar opções da pergunta 24
      const options24 = await client.query(
        'SELECT * FROM answer_options WHERE question_id = 24 ORDER BY id'
      );
      
      console.log(`📊 Opções da pergunta 24: ${options24.rows.length}`);
      options24.rows.forEach(opt => {
        console.log(`  - ${opt.option_text}`);
      });
      
      if (options24.rows.length >= 4) {
        console.log('✅ Pergunta 24 já tem opções suficientes!');
        return;
      }
    }
    
    // Verificar qual quiz_id e category_id usar
    const sampleQuestion = await client.query(
      'SELECT quiz_id, category_id FROM questions LIMIT 1'
    );
    
    const quiz_id = sampleQuestion.rows[0]?.quiz_id || 1;
    const category_id = sampleQuestion.rows[0]?.category_id || 1;
    
    console.log(`🎯 Usando quiz_id: ${quiz_id}, category_id: ${category_id}`);
    
    // Criar pergunta 24 se não existir
    if (question24.rows.length === 0) {
      console.log('➕ Criando pergunta 24...');
      
      await client.query(`
        INSERT INTO questions (id, quiz_id, category_id, question_text, question_order, is_active, country, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
      `, [24, quiz_id, category_id, 'What attracts you most to a person?', 24, true, 'US']);
      
      console.log('✅ Pergunta 24 criada!');
    }
    
    // Limpar opções existentes da pergunta 24
    await client.query('DELETE FROM answer_options WHERE question_id = 24');
    console.log('🗑️ Opções antigas removidas');
    
    // Adicionar as 4 opções corretas
    console.log('➕ Adicionando opções para pergunta 24...');
    
    const options = [
      { text: 'Physical appearance', order: 1, weight: '{"extrovert": 1, "introvert": 0, "thinking": 0, "feeling": 1, "judging": 0, "perceiving": 1}' },
      { text: 'Sense of humor', order: 2, weight: '{"extrovert": 2, "introvert": 1, "thinking": 1, "feeling": 2, "judging": 1, "perceiving": 2}' },
      { text: 'Intelligence', order: 3, weight: '{"extrovert": 1, "introvert": 2, "thinking": 2, "feeling": 1, "judging": 2, "perceiving": 1}' },
      { text: 'Kindness', order: 4, weight: '{"extrovert": 1, "introvert": 1, "thinking": 0, "feeling": 2, "judging": 1, "perceiving": 1}' }
    ];
    
    for (let i = 0; i < options.length; i++) {
      const option = options[i];
      
      await client.query(`
        INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country, created_at)
        VALUES ($1, $2, $3, $4, $5, NOW())
      `, [24, option.text, option.order, option.weight, 'US']);
      
      console.log(`  ✅ Adicionada: ${option.text}`);
    }
    
    // Verificar resultado final
    const finalOptions = await client.query(
      'SELECT * FROM answer_options WHERE question_id = 24 ORDER BY option_order'
    );
    
    console.log(`\n🎉 Resultado final: ${finalOptions.rows.length} opções para pergunta 24`);
    finalOptions.rows.forEach(option => {
      console.log(`  - ${option.option_text}`);
    });
    
    // Verificar se a pergunta aparece no quiz
    const totalQuestions = await client.query(
      'SELECT COUNT(*) as total FROM questions WHERE is_active = true'
    );
    
    console.log(`\n📊 Total de perguntas ativas: ${totalQuestions.rows[0].total}`);
    
  } catch (error) {
    console.error('❌ Erro ao criar pergunta 24:', error.message);
    throw error;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    console.log('🚀 Iniciando criação da pergunta 24...');
    await createQuestion24();
    console.log('✅ Criação concluída!');
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

module.exports = { createQuestion24 };