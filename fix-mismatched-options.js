const db = require('./database');

async function fixMismatchedOptions() {
    try {
        console.log('Corrigindo opções incorretas...');
        
        // Pergunta 16: "Como você prefere passar uma noite perfeita com seu parceiro?"
        // As opções corretas deveriam ser sobre atividades noturnas, não sobre valores de relacionamento
        
        const correctOptions = [
            { id: 65, text: "Assistindo um filme em casa, abraçados no sofá." },
            { id: 66, text: "Saindo para jantar em um restaurante romântico." },
            { id: 68, text: "Cozinhando uma refeição especial juntos." },
            { id: 81, text: "Tendo uma conversa profunda sobre nossos sonhos." }
        ];
        
        console.log('Atualizando opções da pergunta 16...');
        
        for (let option of correctOptions) {
            if (db.dbType === 'postgresql') {
                await db.pool.query(
                    'UPDATE answer_options SET option_text = $1 WHERE id = $2 AND country = $3',
                    [option.text, option.id, 'pt_BR']
                );
            } else {
                await new Promise((resolve, reject) => {
                    db.pool.run(
                        'UPDATE answer_options SET option_text = ? WHERE id = ? AND country = ?',
                        [option.text, option.id, 'pt_BR'],
                        function(err) {
                            if (err) reject(err);
                            else resolve();
                        }
                    );
                });
            }
            console.log(`✅ Atualizada opção ${option.id}: "${option.text}"`);
        }
        
        // Remover opções extras (IDs 82, 83, 84) que não fazem sentido para esta pergunta
        const extraOptionIds = [82, 83, 84];
        
        for (let optionId of extraOptionIds) {
            if (db.dbType === 'postgresql') {
                await db.pool.query(
                    'DELETE FROM answer_options WHERE id = $1 AND country = $2',
                    [optionId, 'pt_BR']
                );
            } else {
                await new Promise((resolve, reject) => {
                    db.pool.run(
                        'DELETE FROM answer_options WHERE id = ? AND country = ?',
                        [optionId, 'pt_BR'],
                        function(err) {
                            if (err) reject(err);
                            else resolve();
                        }
                    );
                });
            }
            console.log(`🗑️  Removida opção extra ${optionId}`);
        }
        
        // Verificar pergunta 22 que também tem uma opção estranha
        // "Tento entender a perspectiva deles antes de reagir" não é sobre como expressar amor
        
        console.log('\nCorrigindo pergunta 22...');
        const newOption22 = "Fazendo pequenos gestos carinhosos no dia a dia.";
        
        if (db.dbType === 'postgresql') {
            await db.pool.query(
                'UPDATE answer_options SET option_text = $1 WHERE id = $2 AND country = $3',
                [newOption22, 79, 'pt_BR']
            );
        } else {
            await new Promise((resolve, reject) => {
                db.pool.run(
                    'UPDATE answer_options SET option_text = ? WHERE id = ? AND country = ?',
                    [newOption22, 79, 'pt_BR'],
                    function(err) {
                        if (err) reject(err);
                        else resolve();
                    }
                );
            });
        }
        
        console.log(`✅ Corrigida opção 79: "${newOption22}"`);
        
        console.log('\n✅ Correções concluídas!');
        
    } catch (error) {
        console.error('Erro:', error);
    }
    
    process.exit(0);
}

fixMismatchedOptions();