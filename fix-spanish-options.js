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

async function fixSpanishOptions() {
  try {
    console.log('🔧 Corrigindo opções em espanhol...');
    
    // Mapeamento das questões em espanhol com suas opções corretas
    const spanishQuestions = {
      // Q17: ¿Cómo prefieres pasar una noche perfecta con tu pareja?
      17: [
        translations.quiz.questions.q1_option_1, // "Una cena romántica en casa con velas"
        translations.quiz.questions.q1_option_2, // "Salir a un restaurante elegante"
        translations.quiz.questions.q1_option_3, // "Ver una película juntos en el sofá"
        translations.quiz.questions.q1_option_4  // "Ir a un concierto o evento en vivo"
      ],
      // Q19: ¿Cómo manejas los conflictos en tu relación?
      19: [
        translations.quiz.questions.q2_option_1, // "Hablo inmediatamente sobre el problema"
        translations.quiz.questions.q2_option_2, // "Tomo tiempo para pensar antes de hablar"
        translations.quiz.questions.q2_option_3, // "Trato de evitar la confrontación"
        translations.quiz.questions.q2_option_4  // "Busco un compromiso que funcione para ambos"
      ],
      // Q21: ¿Qué es lo más importante para ti en una relación?
      21: [
        translations.quiz.questions.q3_option_1, // "Comunicación abierta y honesta"
        translations.quiz.questions.q3_option_2, // "Confianza y lealtad mutua"
        translations.quiz.questions.q3_option_3, // "Diversión y aventura compartida"
        translations.quiz.questions.q3_option_4  // "Apoyo emocional y comprensión"
      ],
      // Q23: ¿Cómo expresas tu amor?
      23: [
        translations.quiz.questions.q4_option_1, // "A través de palabras de afirmación"
        translations.quiz.questions.q4_option_2, // "Con actos de servicio"
        translations.quiz.questions.q4_option_3, // "Dando regalos significativos"
        translations.quiz.questions.q4_option_4  // "Con contacto físico y cercanía"
      ],
      // Q26: ¿Qué te atrae más de una persona?
      26: [
        translations.quiz.questions.q5_option_1, // "Su inteligencia y conversación"
        translations.quiz.questions.q5_option_2, // "Su sentido del humor"
        translations.quiz.questions.q5_option_3, // "Su estabilidad emocional"
        translations.quiz.questions.q5_option_4  // "Su pasión y energía"
      ]
    };
    
    // Pesos de personalidade das questões originais em inglês
    const personalityWeights = {
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
    
    // Para cada questão em espanhol
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
        
        const result = await pool.query(`
          INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country, created_at)
          VALUES ($1, $2, $3, $4, $5, NOW())
          RETURNING id
        `, [qId, optionText, i, JSON.stringify(weights), 'es_ES']);
        
        console.log(`  ✅ Adicionada opção ${i + 1}: "${optionText}"`);
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

fixSpanishOptions();