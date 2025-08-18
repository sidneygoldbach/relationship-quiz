const db = require('./database');

async function checkOptionsCount() {
    try {
        console.log('Verificando número de opções por pergunta...');
        
        const questions = await db.getQuestionsByQuizIdAndLocale(1, 'pt_BR');
        console.log(`Total de perguntas: ${questions.length}`);
        
        for (let q of questions) {
            const options = await db.getAnswerOptionsByQuestionIdAndLocale(q.id, 'pt_BR');
            console.log(`Pergunta ${q.id}: "${q.question_text.substring(0, 60)}..." - ${options.length} opções`);
            
            // Mostrar as opções para identificar problemas
            options.forEach((opt, index) => {
                console.log(`  ${index + 1}. ${opt.option_text}`);
            });
            console.log('---');
        }
        
    } catch (error) {
        console.error('Erro:', error);
    }
    
    process.exit(0);
}

checkOptionsCount();