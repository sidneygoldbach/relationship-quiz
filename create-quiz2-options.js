const database = require('./database.js');

// Opções para as perguntas do Quiz 2 (Relacionamentos)
const quiz2Options = {
  // Pergunta 6: Como você lida com conflitos?
  6: [
    { text: "Abordo os problemas imediatamente e diretamente", weight: {"communicator": 3, "independent": 1}, order: 0 },
    { text: "Preciso de tempo para processar antes de discutir", weight: {"independent": 3, "loyalist": 1}, order: 1 },
    { text: "Tento encontrar um compromisso que funcione para todos", weight: {"harmonizer": 3, "nurturer": 1}, order: 2 },
    { text: "Às vezes evito confrontos para manter a paz", weight: {"harmonizer": 2, "nurturer": 2}, order: 3 }
  ],
  
  // Pergunta 11: O que é mais importante em um relacionamento?
  11: [
    { text: "Comunicação aberta e honesta", weight: {"communicator": 3, "loyalist": 1}, order: 0 },
    { text: "Confiança e lealdade mútua", weight: {"loyalist": 3, "nurturer": 1}, order: 1 },
    { text: "Apoio emocional e compreensão", weight: {"nurturer": 3, "harmonizer": 1}, order: 2 },
    { text: "Respeito pela independência individual", weight: {"independent": 3, "communicator": 1}, order: 3 }
  ],
  
  // Pergunta 16: Como você expressa amor?
  16: [
    { text: "Através de palavras de afirmação", weight: {"communicator": 3, "nurturer": 1}, order: 0 },
    { text: "Através de atos de serviço", weight: {"nurturer": 3, "loyalist": 1}, order: 1 },
    { text: "Passando tempo de qualidade juntos", weight: {"harmonizer": 3, "loyalist": 1}, order: 2 },
    { text: "Dando espaço e liberdade", weight: {"independent": 3, "harmonizer": 1}, order: 3 }
  ],
  
  // Pergunta 21: Como você lida com mudanças no relacionamento?
  21: [
    { text: "Adapto-me facilmente às mudanças", weight: {"harmonizer": 3, "independent": 1}, order: 0 },
    { text: "Preciso de tempo para me ajustar", weight: {"loyalist": 3, "independent": 1}, order: 1 },
    { text: "Gosto de discutir as mudanças abertamente", weight: {"communicator": 3, "loyalist": 1}, order: 2 },
    { text: "Prefiro mudanças graduais", weight: {"nurturer": 3, "harmonizer": 1}, order: 3 }
  ]
};

async function createQuiz2Options() {
  try {
    console.log('🚀 Criando opções para o Quiz 2...');
    
    // Para cada pergunta, criar opções em português e inglês
    for (const [questionId, options] of Object.entries(quiz2Options)) {
      console.log(`\n📝 Criando opções para pergunta ${questionId}...`);
      
      // Criar opções em português (pt_BR)
      for (const option of options) {
        // Usar SQL direto para incluir o campo country
        const query = `INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
                       VALUES (${parseInt(questionId)}, '${option.text.replace(/'/g, "''")}', ${option.order}, '${JSON.stringify(option.weight)}', 'pt_BR')`;
        await database.executeRawSQL(query);
      }
      
      // Criar versões em inglês (tradução básica)
      const englishOptions = {
        6: [
          "I address issues immediately and directly",
          "I need time to process before discussing", 
          "I try to find a compromise that works for everyone",
          "I sometimes avoid confrontation to keep the peace"
        ],
        11: [
          "Open and honest communication",
          "Trust and mutual loyalty",
          "Emotional support and understanding", 
          "Respect for individual independence"
        ],
        16: [
          "Through words of affirmation",
          "Through acts of service",
          "Spending quality time together",
          "Giving space and freedom"
        ],
        21: [
          "I adapt easily to changes",
          "I need time to adjust",
          "I like to discuss changes openly",
          "I prefer gradual changes"
        ]
      };
      
      // Criar opções em inglês (en_US)
      for (let i = 0; i < options.length; i++) {
        const query = `INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) 
                       VALUES (${parseInt(questionId)}, '${englishOptions[questionId][i].replace(/'/g, "''")}', ${options[i].order}, '${JSON.stringify(options[i].weight)}', 'en_US')`;
        await database.executeRawSQL(query);
      }
      
      console.log(`✅ Opções criadas para pergunta ${questionId}`);
    }
    
    // Verificar se as opções foram criadas
    console.log('\n🔍 Verificando opções criadas...');
    for (const questionId of Object.keys(quiz2Options)) {
      const ptOptions = await database.getAnswerOptionsByQuestionIdAndLocale(parseInt(questionId), 'pt_BR');
      const enOptions = await database.getAnswerOptionsByQuestionIdAndLocale(parseInt(questionId), 'en_US');
      console.log(`Pergunta ${questionId}: ${ptOptions.length} opções (pt_BR), ${enOptions.length} opções (en_US)`);
    }
    
    console.log('\n🎉 Opções do Quiz 2 criadas com sucesso!');
    
  } catch (error) {
    console.error('❌ Erro ao criar opções:', error);
  } finally {
    process.exit(0);
  }
}

// Executar se chamado diretamente
if (require.main === module) {
  createQuiz2Options();
}

module.exports = { createQuiz2Options };