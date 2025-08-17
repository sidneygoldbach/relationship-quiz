const database = require('./database.js');

// Portuguese translations for answer options mapped by question content
const portugueseOptionsByContent = {
    'Como você lida com conflitos em seu relacionamento': [
        "Prefiro abordar os problemas imediatamente e diretamente.",
        "Preciso de tempo para processar antes de discutir o problema.", 
        "Tento encontrar um compromisso que funcione para todos.",
        "Às vezes evito confrontos para manter a paz."
    ],
    'O que é mais importante para você em um relacionam': [
        "Comunicação aberta e honesta.",
        "Confiança e lealdade.",
        "Apoio emocional e compreensão.",
        "Crescimento e experiências compartilhadas."
    ],
    'Como você expressa seu amor': [
        "Através do toque físico e proximidade.",
        "Dando presentes ou fazendo atos de serviço atenciosos.",
        "Com palavras de afirmação e elogios.",
        "Passando tempo de qualidade juntos."
    ],
    'Como você prefere passar uma noite perfeita com se': [
        "Assumir a liderança e tomar decisões com confiança.",
        "Discutir todas as opções completamente antes de decidir juntos.",
        "Considerar as necessidades do meu parceiro primeiro.",
        "Ser flexível e seguir o fluxo."
    ],
    'O que mais te atrai em uma pessoa': [
        "Inteligência e senso de humor.",
        "Bondade e compaixão.",
        "Confiança e ambição.",
        "Criatividade e espontaneidade."
    ]
};

async function addPortugueseOptions() {
    try {
        console.log('Adding Portuguese answer options...');
        
        // Get Portuguese questions
        const portugueseQuestions = await database.getQuestionsByQuizIdAndLocale(1, 'pt_BR');
        console.log('Found', portugueseQuestions.length, 'Portuguese questions');
        
        // Get English questions to get the personality weights
        const englishQuestions = await database.getQuestionsByQuizIdAndLocale(1, 'en_US');
        
        for (const ptQuestion of portugueseQuestions) {
            const questionId = ptQuestion.id;
            const questionStart = ptQuestion.question_text.substring(0, 50);
            
            console.log(`\nProcessing question ${questionId}: ${ptQuestion.question_text}`);
            
            // Find matching Portuguese options by question content
            let portugueseOptions = null;
            for (const [key, options] of Object.entries(portugueseOptionsByContent)) {
                if (questionStart.includes(key)) {
                    portugueseOptions = options;
                    break;
                }
            }
            
            if (portugueseOptions) {
                // Find corresponding English question to get weights
                let englishOptions = [];
                for (const enQuestion of englishQuestions) {
                    const enOptions = await database.getAnswerOptionsByQuestionIdAndLocale(enQuestion.id, 'en_US');
                    if (enOptions.length === portugueseOptions.length) {
                        englishOptions = enOptions;
                        break;
                    }
                }
                
                // Insert Portuguese options
                for (let i = 0; i < portugueseOptions.length; i++) {
                    const portugueseText = portugueseOptions[i];
                    const englishOption = englishOptions[i];
                    
                    if (englishOption) {
                        // Insert Portuguese option with same weights as English
                        if (database.dbType === 'postgresql') {
                            const insertQuery = `
                                INSERT INTO answer_options (question_id, option_text, personality_weight, country)
                                VALUES ($1, $2, $3, $4)
                            `;
                            
                            await database.pool.query(insertQuery, [
                                questionId,
                                portugueseText,
                                englishOption.personality_weight,
                                'pt_BR'
                            ]);
                        } else {
                            // SQLite version
                            const insertQuery = `
                                INSERT INTO answer_options (question_id, option_text, personality_weight, country)
                                VALUES (${questionId}, '${portugueseText.replace(/'/g, "''")}', '${englishOption.personality_weight}', 'pt_BR')
                            `;
                            
                            await database.executeRawSQL(insertQuery);
                        }
                        
                        console.log(`  Added: ${portugueseText}`);
                    }
                }
            } else {
                console.log(`No Portuguese translation available for question: ${questionStart}`);
            }
        }
        
        console.log('\n✅ Portuguese answer options added successfully!');
        
        // Verify the additions
        console.log('\nVerification:');
        for (const question of portugueseQuestions) {
            const options = await database.getAnswerOptionsByQuestionIdAndLocale(question.id, 'pt_BR');
            console.log(`Question ${question.id}: ${options.length} options`);
        }
        
    } catch (error) {
        console.error('Error adding Portuguese options:', error);
    } finally {
        process.exit(0);
    }
}

addPortugueseOptions();