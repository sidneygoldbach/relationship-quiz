const { pool, dbType, createQuiz, executeRawSQL } = require('./database');

// Supported locales
const LOCALES = ['en_US', 'pt_BR', 'es_ES', 'fr_FR'];

// Quiz types to create (keeping quiz 1 intact)
const QUIZ_TYPES = [
    { id: 2, title: '🔧 Professional Coach Quiz', description: '🔧 Professional relationship coaching quiz' },
    { id: 3, title: '🔧 Romantic Coach Quiz', description: '🔧 Romantic relationship coaching quiz' },
    { id: 4, title: '🔧 Family Coach Quiz', description: '🔧 Family relationship coaching quiz' },
    { id: 5, title: '🔧 Friendship Coach Quiz', description: '🔧 Friendship relationship coaching quiz' },
    { id: 6, title: '🔧 Personal Growth Quiz', description: '🔧 Personal growth and development quiz' }
];

// Personality types for each quiz
const PERSONALITY_TYPES = [
    { key: 'type_a', name: 'Type A' },
    { key: 'type_b', name: 'Type B' },
    { key: 'type_c', name: 'Type C' }
];

async function createQuizzes() {
    console.log('Creating quizzes...');
    
    for (const quiz of QUIZ_TYPES) {
        try {
            // Check if quiz already exists
            const existingQuiz = await executeRawSQL(`SELECT id FROM quizzes WHERE id = ${quiz.id}`);
            
            if (!existingQuiz || existingQuiz.length === 0) {
                await executeRawSQL(
                    `INSERT INTO quizzes (id, title, description, result_title, price, currency) VALUES (${quiz.id}, '${quiz.title}', '${quiz.description}', 'Personality Type', 100, 'usd')`
                );
                console.log(`✅ Created quiz ${quiz.id}: ${quiz.title}`);
            } else {
                console.log(`⚠️  Quiz ${quiz.id} already exists, skipping...`);
            }
        } catch (error) {
            console.error(`❌ Error creating quiz ${quiz.id}:`, error.message);
        }
    }
}

async function createQuestionsAndOptions() {
    console.log('Creating questions and options...');
    
    for (const quiz of QUIZ_TYPES) {
        for (const locale of LOCALES) {
            console.log(`Creating questions for Quiz ${quiz.id} - ${locale}`);
            
            // Create 5 questions per quiz per locale
            for (let questionNum = 1; questionNum <= 5; questionNum++) {
                try {
                    const questionText = `🔧 Pergunta ${questionNum} - Quiz=${quiz.id} - ${locale}`;
                    
                    // Insert question
                    const questionResult = await executeRawSQL(
                        `INSERT INTO questions (quiz_id, question_text, question_order, country) VALUES (${quiz.id}, '${questionText}', ${questionNum}, '${locale}') RETURNING id`
                    );
                    
                    const questionId = questionResult[0].id;
                    
                    // Create 4 options per question
                    for (let optionNum = 1; optionNum <= 4; optionNum++) {
                        const optionText = `🔧 Opcao ${optionNum} - Pergunta ${questionNum} - Quiz=${quiz.id} - ${locale}`;
                        
                        // Simple personality weight distribution
                        const personalityWeight = {
                            type_a: optionNum === 1 ? 3 : optionNum === 2 ? 1 : 0,
                            type_b: optionNum === 2 ? 3 : optionNum === 3 ? 1 : 0,
                            type_c: optionNum === 3 ? 3 : optionNum === 4 ? 1 : 0
                        };
                        
                        await executeRawSQL(
                            `INSERT INTO answer_options (question_id, option_text, option_order, personality_weight, country) VALUES (${questionId}, '${optionText}', ${optionNum}, '${JSON.stringify(personalityWeight)}', '${locale}')`
                        );
                    }
                    
                    console.log(`✅ Created question ${questionNum} with 4 options for Quiz ${quiz.id} - ${locale}`);
                } catch (error) {
                    console.error(`❌ Error creating question ${questionNum} for Quiz ${quiz.id} - ${locale}:`, error.message);
                }
            }
        }
    }
}

async function createPersonalityTypes() {
    console.log('Creating personality types...');
    
    for (const quiz of QUIZ_TYPES) {
        for (const locale of LOCALES) {
            for (const personalityType of PERSONALITY_TYPES) {
                try {
                    const typeName = `🔧 ${personalityType.name} - Quiz=${quiz.id} - ${locale}`;
                    const description = `🔧 Descricao do ${personalityType.name} - Quiz=${quiz.id} - ${locale}`;
                    
                    const result = await executeRawSQL(
                        `INSERT INTO personality_types (quiz_id, type_name, type_key, description, country) VALUES (${quiz.id}, '${typeName}', '${personalityType.key}', '${description}', '${locale}') RETURNING id`
                    );
                    
                    const personalityTypeId = result[0].id;
                    
                    // Create advice for this personality type
                    const adviceText = `🔧 Conselho para ${personalityType.name} - Quiz=${quiz.id} - ${locale}`;
                    const relationshipAdvice = `🔧 Conselho de relacionamento para ${personalityType.name} - Quiz=${quiz.id} - ${locale}`;
                    
                    await executeRawSQL(
                        `INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES (${personalityTypeId}, 'general', '${adviceText}', 1, '${locale}')`
                    );
                    
                    await executeRawSQL(
                        `INSERT INTO advice (personality_type_id, advice_type, advice_text, advice_order, country) VALUES (${personalityTypeId}, 'relationship', '${relationshipAdvice}', 2, '${locale}')`
                    );
                    
                    console.log(`✅ Created personality type ${personalityType.name} with advice for Quiz ${quiz.id} - ${locale}`);
                } catch (error) {
                    console.error(`❌ Error creating personality type ${personalityType.name} for Quiz ${quiz.id} - ${locale}:`, error.message);
                }
            }
        }
    }
}

async function main() {
    try {
        console.log('🚀 Starting temporary quiz data population...');
        console.log('📊 Using PostgreSQL database');
        
        await createQuizzes();
        await createQuestionsAndOptions();
        await createPersonalityTypes();
        
        console.log('✅ Temporary quiz data population completed successfully!');
        console.log('📈 Summary:');
        console.log(`   - Created ${QUIZ_TYPES.length} quizzes`);
        console.log(`   - Created ${QUIZ_TYPES.length * LOCALES.length * 5} questions`);
        console.log(`   - Created ${QUIZ_TYPES.length * LOCALES.length * 5 * 4} answer options`);
        console.log(`   - Created ${QUIZ_TYPES.length * LOCALES.length * PERSONALITY_TYPES.length} personality types`);
        console.log(`   - Created ${QUIZ_TYPES.length * LOCALES.length * PERSONALITY_TYPES.length * 2} advice entries`);
        
    } catch (error) {
        console.error('❌ Error during population:', error);
    } finally {
        if (pool && pool.end) {
            await pool.end();
        }
        process.exit(0);
    }
}

if (require.main === module) {
    main();
}

module.exports = { main };