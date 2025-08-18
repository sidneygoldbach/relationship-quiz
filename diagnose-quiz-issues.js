const database = require('./database.js');

async function diagnoseQuizIssues() {
    try {
        console.log('=== DIAGNÓSTICO DOS PROBLEMAS DO QUIZ ===\n');
        
        // 1. Verificar todas as perguntas e suas opções
        console.log('1. Verificando perguntas e opções:');
        const questions = await database.executeRawSQL(`
            SELECT 
                q.id,
                q.question_text,
                q.question_order,
                q.country,
                COUNT(ao.id) as option_count
            FROM questions q
            LEFT JOIN answer_options ao ON q.id = ao.question_id
            WHERE q.quiz_id = 1
            GROUP BY q.id, q.question_text, q.question_order, q.country
            ORDER BY q.country, q.question_order
        `);
        
        questions.forEach(q => {
            console.log(`   Pergunta ${q.id} (${q.country}) - Ordem: ${q.question_order} - Opções: ${q.option_count}`);
            console.log(`   Texto: ${q.question_text.substring(0, 60)}...`);
            if (q.option_count === 0) {
                console.log('   ⚠️  PROBLEMA: Esta pergunta não tem opções!');
            }
            console.log('');
        });
        
        // 2. Verificar especificamente a última pergunta de cada país
        console.log('\n2. Verificando últimas perguntas por país:');
        const lastQuestions = await database.executeRawSQL(`
            SELECT 
                q.id,
                q.question_text,
                q.question_order,
                q.country,
                COUNT(ao.id) as option_count
            FROM questions q
            LEFT JOIN answer_options ao ON q.id = ao.question_id
            WHERE q.quiz_id = 1
            AND q.question_order = (
                SELECT MAX(q2.question_order) 
                FROM questions q2 
                WHERE q2.country = q.country AND q2.quiz_id = 1
            )
            GROUP BY q.id, q.question_text, q.question_order, q.country
            ORDER BY q.country
        `);
        
        lastQuestions.forEach(q => {
            console.log(`   Última pergunta ${q.country}: ID ${q.id} - Ordem: ${q.question_order} - Opções: ${q.option_count}`);
            console.log(`   Texto: ${q.question_text}`);
            if (q.option_count === 0) {
                console.log('   🚨 PROBLEMA CRÍTICO: Última pergunta sem opções!');
            }
            console.log('');
        });
        
        // 3. Verificar opções detalhadas das perguntas problemáticas
        console.log('\n3. Verificando opções das perguntas com problemas:');
        const problemQuestions = questions.filter(q => q.option_count === 0);
        
        for (const pq of problemQuestions) {
            console.log(`   Pergunta ${pq.id} (${pq.country}):`);
            const options = await database.executeRawSQL(`
                SELECT id, option_text, option_order
                FROM answer_options
                WHERE question_id = $1
                ORDER BY option_order
            `, [pq.id]);
            
            if (options.length === 0) {
                console.log('     ❌ Nenhuma opção encontrada!');
            } else {
                options.forEach(opt => {
                    console.log(`     - ${opt.option_order}: ${opt.option_text}`);
                });
            }
            console.log('');
        }
        
        // 4. Verificar se há perguntas duplicadas ou com ordens conflitantes
        console.log('\n4. Verificando possíveis duplicatas ou conflitos de ordem:');
        const orderConflicts = await database.executeRawSQL(`
            SELECT 
                country,
                question_order,
                COUNT(*) as count,
                STRING_AGG(CAST(id AS TEXT), ', ') as question_ids
            FROM questions
            WHERE quiz_id = 1
            GROUP BY country, question_order
            HAVING COUNT(*) > 1
            ORDER BY country, question_order
        `);
        
        if (orderConflicts.length > 0) {
            console.log('   ⚠️  Conflitos de ordem encontrados:');
            orderConflicts.forEach(conflict => {
                console.log(`     ${conflict.country} - Ordem ${conflict.question_order}: ${conflict.count} perguntas (IDs: ${conflict.question_ids})`);
            });
        } else {
            console.log('   ✅ Nenhum conflito de ordem encontrado.');
        }
        
        // 5. Verificar total de perguntas por país
        console.log('\n5. Total de perguntas por país:');
        const totals = await database.executeRawSQL(`
            SELECT 
                country,
                COUNT(*) as total_questions,
                MIN(question_order) as min_order,
                MAX(question_order) as max_order
            FROM questions
            WHERE quiz_id = 1
            GROUP BY country
            ORDER BY country
        `);
        
        totals.forEach(total => {
            console.log(`   ${total.country}: ${total.total_questions} perguntas (ordem ${total.min_order} a ${total.max_order})`);
        });
        
        console.log('\n=== FIM DO DIAGNÓSTICO ===');
        
    } catch (error) {
        console.error('Erro durante diagnóstico:', error);
    } finally {
        // Database connection will be handled by the module
        process.exit(0);
    }
}

diagnoseQuizIssues();