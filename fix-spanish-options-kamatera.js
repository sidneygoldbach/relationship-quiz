const { Pool } = require('pg');
require('dotenv').config();
const fs = require('fs');
const path = require('path');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD
});

// Carregar traduções do arquivo es_ES.json
const translationsPath = path.join(__dirname, 'locales', 'es_ES.json');
const translations = JSON.parse(fs.readFileSync(translationsPath, 'utf8'));

async function fixSpanishOptionsKamatera() {
  try {
    console.log('🔧 Corrigindo opções em espanhol no Kamatera...');
    
    // Primeiro, verificar quais questões existem no banco
    console.log('🔍 Verificando questões existentes...');
    const existingQuestions = await pool.query(`
      SELECT id, question_text 
      FROM questions 
      WHERE quiz_id = 1 
      ORDER BY id
    `);
    
    console.log(`📊 Encontradas ${existingQuestions.rows.length} questões:`);
    existingQuestions.rows.forEach(q => {
      console.log(`  - Questão ${q.id}: ${q.question_text.substring(0, 50)}...`);
    });
    
    // Mapeamento das questões em espanhol com suas opções corretas
    // Baseado nas questões que realmente existem no Kamatera
    const spanishQuestions = {};
    const personalityWeights = {};
    
    // Verificar se as questões em espanhol existem e mapear corretamente
    const questionMappings = [
      { id: 17, options: ['q1_option_1', 'q1_option_2', 'q1_option_3', 'q1_option_4'] },
      { id: 19, options: ['q2_option_1', 'q2_option_2', 'q2_option_3', 'q2_option_4'] },
      { id: 21, options: ['q3_option_1', 'q3_option_2', 'q3_option_3', 'q3_option_4'] },
      { id: 23, options: ['q4_option_1', 'q4_option_2', 'q4_option_3', 'q4_option_4'] },
      { id: 26, options: ['q5_option_1', 'q5_option_2', 'q5_option_3', 'q5_option_4'] }
    ];
    
    // Pesos de personalidade padrão
    const defaultWeights = {
      17: [ // Q1 weights
        {"romantic": 3, "adventurer": 1, "nurturer": 2, "communicator": 1},
        {"romantic": 2, "adventurer": 3, "nurturer": 1, "communicator": 1},
        {"romantic": 1, "adventurer": 1, "nurturer": 3, "communicator": 2},
        {"romantic": 1, "adventurer": 3, "nurturer": 1, "communicator": 2}
      ],
      19: [ // Q2 weights
        {"romantic": 1, "adventurer": 2, "nurturer": 1, "communicator": 3},
        {"romantic": 2, "adventurer": 1, "nurturer": 2, "communicator": 3},
        {"romantic": 2, "adventurer": 1, "nurturer": 3, "communicator": 1},
        {"romantic": 2, "adventurer": 2, "nurturer": 2, "communicator": 3}
      ],
      21: [ // Q3 weights
        {"romantic": 2, "adventurer": 1, "nurturer": 2, "communicator": 3},
        {"romantic": 2, "adventurer": 1, "nurturer": 3, "communicator": 2},
        {"romantic": 1, "adventurer": 3, "nurturer": 1, "communicator": 1},
        {"romantic": 3, "adventurer": 1, "nurturer": 3, "communicator": 1}
      ],
      23: [ // Q4 weights
        {"romantic": 3, "adventurer": 1, "nurturer": 1, "communicator": 3},
        {"romantic": 1, "adventurer": 1, "nurturer": 3, "communicator": 1},
        {"romantic": 3, "adventurer": 2, "nurturer": 2, "communicator": 1},
        {"romantic": 3, "adventurer": 1, "nurturer": 3, "communicator": 1}
      ],
      26: [ // Q5 weights
        {"romantic": 1, "adventurer": 1, "nurturer": 1, "communicator": 3},
        {"romantic": 2, "adventurer": 3, "nurturer": 2, "communicator": 2},
        {"romantic": 2, "adventurer": 1, "nurturer": 3, "communicator": 2},
        {"romantic": 3, "adventurer": 3, "nurturer": 1, "communicator": 1}
      ]
    };
    
    // Verificar quais questões realmente existem e preparar os dados
    for (const mapping of questionMappings) {
      const questionExists = existingQuestions.rows.find(q => q.id === mapping.id);
      if (questionExists) {
        console.log(`✅ Questão ${mapping.id} existe - preparando opções`);
        spanishQuestions[mapping.id] = mapping.options.map(optionKey => 
          translations.quiz.questions[optionKey]
        );
        personalityWeights[mapping.id] = defaultWeights[mapping.id];
      } else {
        console.log(`⚠️  Questão ${mapping.id} não existe - pulando`);
      }
    }
    
    if (Object.keys(spanishQuestions).length === 0) {
      console.log('❌ Nenhuma questão em espanhol encontrada para corrigir');
      return;
    }
    
    console.log(`\n🎯 Processando ${Object.keys(spanishQuestions).length} questões em espanhol...`);
    
    // Para cada questão em espanhol que existe
    for (const [questionId, options] of Object.entries(spanishQuestions)) {
      const qId = parseInt(questionId);
      console.log(`\n📝 Processando questão ${qId}...`);
      
      // Primeiro, remover opções existentes em espanhol para esta questão
      const deleteResult = await pool.query(
        'DELETE FROM answer_options WHERE question_id = $1 AND country = $2',
        [qId, 'es_ES']
      );
      console.log(`  🗑️  Removidas ${deleteResult.rowCount} opções antigas`);
      
      // Adicionar as novas opções corretas
      for (let i = 0; i < options.length; i++) {
        const optionText = options[i];
        const weights = personalityWeights[qId] ? personalityWeights[qId][i] : {};
        
        try {
          const result = await pool.query(`
            INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country, created_at)
            VALUES ($1, $2, $3, $4, $5, NOW())
            RETURNING id
          `, [qId, optionText, i, JSON.stringify(weights), 'es_ES']);
          
          console.log(`  ✅ Adicionada opção ${i + 1}: "${optionText}"`);
        } catch (error) {
          console.error(`  ❌ Erro ao adicionar opção ${i + 1}:`, error.message);
        }
      }
    }
    
    console.log('\n✅ Correção das opções em espanhol concluída!');
    
    // Verificar resultado final
    console.log('\n📊 Verificando resultado final...');
    const finalCheck = await pool.query(`
      SELECT q.id as question_id, q.question_text, ao.option_order, ao.option_text 
      FROM questions q 
      JOIN answer_options ao ON q.id = ao.question_id 
      WHERE q.quiz_id = 1 AND ao.country = 'es_ES' 
      ORDER BY q.id, ao.option_order
    `);
    
    let currentQuestionId = null;
    for (const row of finalCheck.rows) {
      if (row.question_id !== currentQuestionId) {
        console.log(`\n🇪🇸 Questão ${row.question_id}: ${row.question_text}`);
        currentQuestionId = row.question_id;
      }
      console.log(`  ${row.option_order + 1}. ${row.option_text}`);
    }
    
    // Contar total de opções
    const countResult = await pool.query(
      'SELECT COUNT(*) as total FROM answer_options WHERE country = $1',
      ['es_ES']
    );
    console.log(`\n📈 Total de opções em espanhol: ${countResult.rows[0].total}`);
    
  } catch (error) {
    console.error('❌ Erro ao corrigir opções em espanhol:', error);
  } finally {
    await pool.end();
  }
}

fixSpanishOptionsKamatera();