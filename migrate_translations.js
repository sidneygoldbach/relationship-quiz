const { pool, dbType, initializeDatabase } = require('./database.js');
const fs = require('fs');
const path = require('path');

// Traduções em espanhol
const esTranslations = {
  "quiz": {
    "title": "Quiz de Personalidad en Relaciones",
    "description": "Descubre tu tipo de personalidad en las relaciones",
    "start_button": "Comenzar Quiz",
    "next_button": "Siguiente",
    "previous_button": "Anterior",
    "submit_button": "Enviar",
    "loading": "Cargando...",
    "questions": {
      "q1": "¿Cómo prefieres pasar una noche perfecta con tu pareja?",
      "q1_option_1": "Una cena romántica en casa con velas",
      "q1_option_2": "Salir a un restaurante elegante",
      "q1_option_3": "Ver una película juntos en el sofá",
      "q1_option_4": "Ir a un concierto o evento en vivo",
      "q2": "¿Cómo manejas los conflictos en tu relación?",
      "q2_option_1": "Hablo inmediatamente sobre el problema",
      "q2_option_2": "Tomo tiempo para pensar antes de hablar",
      "q2_option_3": "Trato de evitar la confrontación",
      "q2_option_4": "Busco un compromiso que funcione para ambos",
      "q3": "¿Qué es lo más importante para ti en una relación?",
      "q3_option_1": "Comunicación abierta y honesta",
      "q3_option_2": "Confianza y lealtad mutua",
      "q3_option_3": "Diversión y aventura compartida",
      "q3_option_4": "Apoyo emocional y comprensión",
      "q4": "¿Cómo expresas tu amor?",
      "q4_option_1": "A través de palabras de afirmación",
      "q4_option_2": "Con actos de servicio",
      "q4_option_3": "Dando regalos significativos",
      "q4_option_4": "Con contacto físico y cercanía",
      "q5": "¿Qué te atrae más de una persona?",
      "q5_option_1": "Su inteligencia y conversación",
      "q5_option_2": "Su sentido del humor",
      "q5_option_3": "Su estabilidad emocional",
      "q5_option_4": "Su pasión y energía"
    }
  },
  "personality_types": {
    "romantic": {
      "title": "El Romántico",
      "description": "Eres una persona que valora profundamente la conexión emocional y los gestos románticos. Buscas una relación llena de amor, comprensión y momentos especiales.",
      "advice": "Mantén el equilibrio entre romance y realidad. Comunica tus necesidades emocionales claramente y aprecia los pequeños gestos de amor en la vida cotidiana."
    },
    "adventurer": {
      "title": "El Aventurero",
      "description": "Eres espontáneo y buscas emoción en tu relación. Valoras la libertad, la aventura y las nuevas experiencias compartidas con tu pareja.",
      "advice": "Encuentra una pareja que comparta tu amor por la aventura, pero también aprende a valorar los momentos tranquilos juntos. La estabilidad puede coexistir con la emoción."
    },
    "nurturer": {
      "title": "El Cuidador",
      "description": "Eres naturalmente cariñoso y te enfocas en cuidar y apoyar a tu pareja. Tu felicidad viene de hacer felices a otros y crear un ambiente amoroso.",
      "advice": "Recuerda cuidarte a ti mismo también. Establece límites saludables y asegúrate de que tus propias necesidades también sean atendidas en la relación."
    },
    "communicator": {
      "title": "El Comunicador",
      "description": "Valoras la comunicación abierta y honesta por encima de todo. Crees que los problemas se pueden resolver hablando y buscas una conexión intelectual profunda.",
      "advice": "Continúa priorizando la comunicación, pero también aprende a escuchar sin juzgar. A veces tu pareja necesita ser escuchada más que aconsejada."
    }
  },
  "payment": {
    "title": "Obtén tu Resultado Completo",
    "description": "Desbloquea tu análisis detallado de personalidad y consejos personalizados",
    "price": "Solo $4.99",
    "features": {
      "detailed_analysis": "Análisis detallado de personalidad",
      "personalized_advice": "Consejos personalizados para relaciones",
      "compatibility_guide": "Guía de compatibilidad",
      "relationship_tips": "Consejos para mejorar tu relación"
    },
    "pay_button": "Pagar Ahora",
    "processing": "Procesando pago...",
    "success": "¡Pago exitoso! Redirigiendo a tus resultados...",
    "error": "Error en el pago. Por favor, inténtalo de nuevo."
  },
  "common": {
    "loading": "Cargando...",
    "error": "Error",
    "success": "Éxito",
    "cancel": "Cancelar",
    "confirm": "Confirmar",
    "close": "Cerrar",
    "save": "Guardar",
    "edit": "Editar",
    "delete": "Eliminar",
    "back": "Volver",
    "continue": "Continuar",
    "finish": "Finalizar",
    "email_placeholder": "Ingresa tu email",
    "required_field": "Este campo es obligatorio",
    "invalid_email": "Email inválido"
  }
};

async function migrateTranslations() {
  try {
    console.log('🔄 Iniciando migração de traduções...');
    
    // Inicializar banco de dados
    await initializeDatabase();
    
    // Carregar traduções existentes dos arquivos JSON
    const enTranslations = JSON.parse(fs.readFileSync(path.join(__dirname, 'locales', 'en_US.json'), 'utf8'));
    const ptTranslations = JSON.parse(fs.readFileSync(path.join(__dirname, 'locales', 'pt_BR.json'), 'utf8'));
    
    // Função para inserir traduções de layout
    const insertLayoutTranslations = async (translations, country) => {
      console.log(`📝 Inserindo traduções de layout para ${country}...`);
      
      const flattenObject = (obj, prefix = '') => {
        const flattened = {};
        for (const key in obj) {
          if (typeof obj[key] === 'object' && obj[key] !== null && !Array.isArray(obj[key])) {
            Object.assign(flattened, flattenObject(obj[key], prefix + key + '.'));
          } else {
            flattened[prefix + key] = obj[key];
          }
        }
        return flattened;
      };
      
      const flatTranslations = flattenObject(translations);
      
      for (const [key, value] of Object.entries(flatTranslations)) {
        if (typeof value === 'string') {
          if (dbType === 'postgresql') {
            await pool.query(
              'INSERT INTO layout_locale (country, component_name, text_content) VALUES ($1, $2, $3) ON CONFLICT (country, component_name) DO UPDATE SET text_content = $3',
              [country, key, value]
            );
          } else {
            await new Promise((resolve, reject) => {
              pool.run(
                'INSERT OR REPLACE INTO layout_locale (country, component_name, text_content) VALUES (?, ?, ?)',
                [country, key, value],
                (err) => {
                  if (err) reject(err);
                  else resolve();
                }
              );
            });
          }
        }
      }
    };
    
    // Inserir traduções para todos os idiomas
    await insertLayoutTranslations(enTranslations, 'en_US');
    await insertLayoutTranslations(ptTranslations, 'pt_BR');
    await insertLayoutTranslations(esTranslations, 'es_ES');
    
    // Migrar dados existentes do quiz para incluir traduções
    console.log('🔄 Migrando dados existentes do quiz...');
    
    // Inserir perguntas traduzidas
    const questions = [
      { id: 1, en: "How do you prefer to spend a perfect evening with your partner?", pt: "Como você prefere passar uma noite perfeita com seu parceiro?", es: "¿Cómo prefieres pasar una noche perfecta con tu pareja?" },
      { id: 2, en: "How do you handle conflicts in your relationship?", pt: "Como você lida com conflitos em seu relacionamento?", es: "¿Cómo manejas los conflictos en tu relación?" },
      { id: 3, en: "What's most important to you in a relationship?", pt: "O que é mais importante para você em um relacionamento?", es: "¿Qué es lo más importante para ti en una relación?" },
      { id: 4, en: "How do you express your love?", pt: "Como você expressa seu amor?", es: "¿Cómo expresas tu amor?" },
      { id: 5, en: "What attracts you most to a person?", pt: "O que mais te atrai em uma pessoa?", es: "¿Qué te atrae más de una persona?" }
    ];
    
    for (const question of questions) {
      // Inserir versões em inglês, português e espanhol
      const languages = [{ country: 'en_US', text: question.en }, { country: 'pt_BR', text: question.pt }, { country: 'es_ES', text: question.es }];
      
      for (const lang of languages) {
        if (dbType === 'postgresql') {
          // Verificar se já existe
          const existing = await pool.query(
            'SELECT id FROM questions WHERE quiz_id = $1 AND question_order = $2 AND country = $3',
            [1, question.id, lang.country]
          );
          
          if (existing.rows.length === 0) {
            await pool.query(
              'INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES ($1, $2, $3, $4)',
              [1, lang.text, question.id, lang.country]
            );
          }
        } else {
          await new Promise((resolve, reject) => {
            pool.run(
              'INSERT OR REPLACE INTO questions (id, quiz_id, question_text, question_order, country) VALUES (?, ?, ?, ?, ?)',
              [question.id, 1, lang.text, question.id, lang.country],
              (err) => {
                if (err) reject(err);
                else resolve();
              }
            );
          });
        }
      }
    }
    
    console.log('✅ Migração de traduções concluída com sucesso!');
    console.log('📊 Traduções disponíveis: en_US, pt_BR, es_ES');
    
  } catch (error) {
    console.error('❌ Erro na migração:', error);
    throw error;
  }
}

// Executar migração se chamado diretamente
if (require.main === module) {
  migrateTranslations()
    .then(() => {
      console.log('🎉 Migração concluída!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Falha na migração:', error);
      process.exit(1);
    });
}

module.exports = { migrateTranslations, esTranslations };