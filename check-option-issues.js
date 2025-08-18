const db = require('./database');

async function checkOptionIssues() {
    try {
        console.log('Verificando problemas nas opções...');
        
        const questions = await db.getQuestionsByQuizIdAndLocale(1, 'pt_BR');
        
        for (let q of questions) {
            const options = await db.getAnswerOptionsByQuestionIdAndLocale(q.id, 'pt_BR');
            console.log(`\n=== Pergunta ${q.id} ===`);
            console.log(`Texto: "${q.question_text}"`); 
            console.log(`Número de opções: ${options.length}`);
            
            // Verificar opções duplicadas
            const optionTexts = options.map(opt => opt.option_text);
            const duplicates = optionTexts.filter((item, index) => optionTexts.indexOf(item) !== index);
            
            if (duplicates.length > 0) {
                console.log('⚠️  OPÇÕES DUPLICADAS ENCONTRADAS:', duplicates);
            }
            
            // Mostrar todas as opções com detalhes
            options.forEach((opt, index) => {
                console.log(`  ${index + 1}. [ID: ${opt.id}] [Order: ${opt.option_order}] "${opt.option_text}"`);
                
                // Verificar se o texto da opção parece estar misturado
                if (opt.option_text.includes('?') || opt.option_text.length > 100) {
                    console.log('    ⚠️  Possível texto misturado ou muito longo');
                }
            });
        }
        
    } catch (error) {
        console.error('Erro:', error);
    }
    
    process.exit(0);
}

checkOptionIssues();