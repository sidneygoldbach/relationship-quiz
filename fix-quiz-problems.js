const database = require('./database.js');
const fs = require('fs');
const path = require('path');

async function fixQuizProblems() {
    try {
        console.log('=== CORRIGINDO PROBLEMAS DO QUIZ ===\n');
        
        // 1. Adicionar opções para a pergunta 24 (en_US) - "What attracts you most to a person?"
        console.log('1. Adicionando opções para a pergunta 24 (en_US)...');
        
        const question24Options = [
            {
                text: "Intelligence and sense of humor.",
                order: 1,
                weight: { "communicator": 3, "adventurer": 2, "nurturer": 1, "leader": 2 }
            },
            {
                text: "Kindness and compassion.",
                order: 2,
                weight: { "communicator": 2, "adventurer": 1, "nurturer": 3, "leader": 1 }
            },
            {
                text: "Confidence and ambition.",
                order: 3,
                weight: { "communicator": 1, "adventurer": 3, "nurturer": 1, "leader": 3 }
            },
            {
                text: "Authenticity and genuineness.",
                order: 4,
                weight: { "communicator": 3, "adventurer": 2, "nurturer": 2, "leader": 2 }
            }
        ];
        
        for (const option of question24Options) {
            await database.createAnswerOption(
                24, // question_id
                option.text,
                option.order,
                option.weight
            );
            console.log(`   ✅ Adicionada opção: ${option.text}`);
        }
        
        // 2. Atualizar arquivos de localização para adicionar a chave 'finish_quiz'
        console.log('\n2. Atualizando arquivos de localização...');
        
        // Atualizar pt_BR.json
        const ptBRPath = path.join(__dirname, 'locales', 'pt_BR.json');
        const ptBRContent = JSON.parse(fs.readFileSync(ptBRPath, 'utf8'));
        
        if (!ptBRContent.quiz.finish_quiz) {
            ptBRContent.quiz.finish_quiz = 'Finalizar Quiz';
            fs.writeFileSync(ptBRPath, JSON.stringify(ptBRContent, null, 2));
            console.log('   ✅ Adicionada chave finish_quiz em pt_BR.json');
        } else {
            console.log('   ℹ️  Chave finish_quiz já existe em pt_BR.json');
        }
        
        // Atualizar es_ES.json
        const esESPath = path.join(__dirname, 'locales', 'es_ES.json');
        const esESContent = JSON.parse(fs.readFileSync(esESPath, 'utf8'));
        
        if (!esESContent.quiz) {
            esESContent.quiz = {};
        }
        if (!esESContent.quiz.finish_quiz) {
            esESContent.quiz.finish_quiz = 'Finalizar Quiz';
            fs.writeFileSync(esESPath, JSON.stringify(esESContent, null, 2));
            console.log('   ✅ Adicionada chave finish_quiz em es_ES.json');
        } else {
            console.log('   ℹ️  Chave finish_quiz já existe em es_ES.json');
        }
        
        // Atualizar en_US.json (se existir)
        const enUSPath = path.join(__dirname, 'locales', 'en_US.json');
        if (fs.existsSync(enUSPath)) {
            const enUSContent = JSON.parse(fs.readFileSync(enUSPath, 'utf8'));
            if (!enUSContent.quiz) {
                enUSContent.quiz = {};
            }
            if (!enUSContent.quiz.finish_quiz) {
                enUSContent.quiz.finish_quiz = 'Finish Quiz';
                fs.writeFileSync(enUSPath, JSON.stringify(enUSContent, null, 2));
                console.log('   ✅ Adicionada chave finish_quiz em en_US.json');
            } else {
                console.log('   ℹ️  Chave finish_quiz já existe em en_US.json');
            }
        } else {
            // Criar arquivo en_US.json
            const enUSContent = {
                "quiz": {
                    "title": "Relationship Personality Quiz",
                    "subtitle": "Discover Your Relationship Style",
                    "description": "Take our comprehensive quiz to understand your relationship personality and receive personalized advice for building stronger connections.",
                    "startButton": "Start Quiz",
                    "question": "Question",
                    "of": "of",
                    "previousQuestion": "Previous Question",
                    "nextQuestion": "Next Question",
                    "finish_quiz": "Finish Quiz",
                    "calculateResults": "Calculate Results",
                    "retakeQuiz": "Retake Quiz",
                    "shareResults": "Share Results"
                }
            };
            fs.writeFileSync(enUSPath, JSON.stringify(enUSContent, null, 2));
            console.log('   ✅ Criado arquivo en_US.json com chave finish_quiz');
        }
        
        // 3. Verificar se as correções funcionaram
        console.log('\n3. Verificando correções...');
        
        const question24OptionsCheck = await database.executeRawSQL(`
            SELECT COUNT(*) as count FROM answer_options WHERE question_id = 24
        `);
        
        console.log(`   Pergunta 24 agora tem ${question24OptionsCheck[0].count} opções`);
        
        if (question24OptionsCheck[0].count >= 4) {
            console.log('   ✅ Problema das opções da pergunta 24 corrigido!');
        } else {
            console.log('   ❌ Ainda há problema com as opções da pergunta 24');
        }
        
        console.log('\n=== CORREÇÕES CONCLUÍDAS ===');
        
    } catch (error) {
        console.error('Erro durante correção:', error);
    } finally {
        process.exit(0);
    }
}

fixQuizProblems();