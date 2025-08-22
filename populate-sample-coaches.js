const { pool, dbType, updateQuizCoachInfo, createQuizImage } = require('./database');

async function populateSampleCoaches() {
    try {
        console.log('🎯 Populating sample coaches...');
        
        // Sample coaches data
        const coaches = [
            {
                id: 1, // Assuming existing quiz with id 1
                coach_type: 'relationship_personal',
                coach_category: 'personal',
                coach_title: 'Coach de Relacionamentos Pessoais',
                coach_description: 'Descubra seu perfil em relacionamentos pessoais e aprenda a construir conexões mais profundas e significativas.',
                icon_url: 'https://via.placeholder.com/100x100/FF6B6B/FFFFFF?text=❤️',
                images: [
                    {
                        url: 'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Relacionamentos+Pessoais',
                        type: 'background_image',
                        title: 'Relacionamentos Pessoais',
                        description: 'Construa relacionamentos mais profundos'
                    },
                    {
                        url: 'https://via.placeholder.com/300x300/FF6B6B/FFFFFF?text=💕',
                        type: 'starting_image',
                        title: 'Início do Quiz',
                        description: 'Comece sua jornada de autoconhecimento'
                    }
                ]
            },
            {
                id: 2, // Will create new quiz
                name: 'career_coach',
                title: 'Quiz de Carreira',
                description: 'Descubra seu perfil profissional ideal',
                coach_type: 'career_development',
                coach_category: 'professional',
                coach_title: 'Coach de Desenvolvimento de Carreira',
                coach_description: 'Identifique suas forças profissionais e descubra o caminho ideal para sua carreira.',
                icon_url: 'https://via.placeholder.com/100x100/4ECDC4/FFFFFF?text=💼',
                price: 150,
                currency: 'usd',
                images: [
                    {
                        url: 'https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Desenvolvimento+de+Carreira',
                        type: 'background_image',
                        title: 'Carreira Profissional',
                        description: 'Encontre seu caminho profissional ideal'
                    },
                    {
                        url: 'https://via.placeholder.com/300x300/4ECDC4/FFFFFF?text=🚀',
                        type: 'starting_image',
                        title: 'Acelere sua Carreira',
                        description: 'Descubra seu potencial profissional'
                    }
                ]
            },
            {
                id: 3, // Will create new quiz
                name: 'interview_coach',
                title: 'Quiz de Entrevistas',
                description: 'Prepare-se para entrevistas de emprego',
                coach_type: 'interview_preparation',
                coach_category: 'professional',
                coach_title: 'Coach de Preparação para Entrevistas',
                coach_description: 'Desenvolva confiança e técnicas para se destacar em entrevistas de emprego.',
                icon_url: 'https://via.placeholder.com/100x100/45B7D1/FFFFFF?text=🎯',
                price: 120,
                currency: 'usd',
                images: [
                    {
                        url: 'https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Preparação+Entrevistas',
                        type: 'background_image',
                        title: 'Entrevistas de Sucesso',
                        description: 'Conquiste a vaga dos seus sonhos'
                    },
                    {
                        url: 'https://via.placeholder.com/300x300/45B7D1/FFFFFF?text=✨',
                        type: 'starting_image',
                        title: 'Brilhe na Entrevista',
                        description: 'Mostre seu melhor potencial'
                    }
                ]
            },
            {
                id: 4, // Will create new quiz
                name: 'romantic_conquest',
                title: 'Quiz de Conquistas Amorosas',
                description: 'Descubra seu estilo de conquista',
                coach_type: 'romantic_conquest',
                coach_category: 'romantic',
                coach_title: 'Coach de Conquistas Amorosas',
                coach_description: 'Aprenda técnicas de sedução e conquista para encontrar o amor verdadeiro.',
                icon_url: 'https://via.placeholder.com/100x100/E74C3C/FFFFFF?text=💘',
                price: 180,
                currency: 'usd',
                images: [
                    {
                        url: 'https://via.placeholder.com/800x400/E74C3C/FFFFFF?text=Conquistas+Amorosas',
                        type: 'background_image',
                        title: 'Arte da Conquista',
                        description: 'Domine a arte da sedução'
                    },
                    {
                        url: 'https://via.placeholder.com/300x300/E74C3C/FFFFFF?text=🌹',
                        type: 'starting_image',
                        title: 'Conquiste Corações',
                        description: 'Desperte seu poder de sedução'
                    }
                ]
            },
            {
                id: 5, // Will create new quiz
                name: 'lasting_relationships',
                title: 'Quiz de Relacionamentos Duradouros',
                description: 'Construa relacionamentos que duram',
                coach_type: 'lasting_relationships',
                coach_category: 'romantic',
                coach_title: 'Coach de Relacionamentos Duradouros',
                coach_description: 'Aprenda os segredos para manter relacionamentos saudáveis e duradouros.',
                icon_url: 'https://via.placeholder.com/100x100/9B59B6/FFFFFF?text=💍',
                price: 200,
                currency: 'usd',
                images: [
                    {
                        url: 'https://via.placeholder.com/800x400/9B59B6/FFFFFF?text=Relacionamentos+Duradouros',
                        type: 'background_image',
                        title: 'Amor Duradouro',
                        description: 'Construa um relacionamento para a vida'
                    },
                    {
                        url: 'https://via.placeholder.com/300x300/9B59B6/FFFFFF?text=🏠',
                        type: 'starting_image',
                        title: 'Construa Juntos',
                        description: 'Fortaleça os laços do amor'
                    }
                ]
            }
        ];
        
        for (const coach of coaches) {
            try {
                // Check if quiz exists
                let quizExists = false;
                if (dbType === 'postgresql') {
                    const result = await pool.query('SELECT id FROM quizzes WHERE id = $1', [coach.id]);
                    quizExists = result.rows.length > 0;
                } else {
                    await new Promise((resolve, reject) => {
                        pool.get('SELECT id FROM quizzes WHERE id = ?', [coach.id], (err, row) => {
                            if (err) reject(err);
                            else {
                                quizExists = !!row;
                                resolve();
                            }
                        });
                    });
                }
                
                // Create quiz if it doesn't exist
                if (!quizExists && coach.name) {
                    console.log(`Creating new quiz: ${coach.title}`);
                    if (dbType === 'postgresql') {
                        await pool.query(`
                            INSERT INTO quizzes (id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url)
                            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
                        `, [coach.id, coach.name, coach.title, coach.description, coach.price || 100, coach.currency || 'usd', 
                            coach.coach_type, coach.coach_category, coach.coach_title, coach.coach_description, coach.icon_url]);
                    } else {
                        await new Promise((resolve, reject) => {
                            pool.run(`
                                INSERT INTO quizzes (id, name, title, description, price, currency, coach_type, coach_category, coach_title, coach_description, icon_url)
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                            `, [coach.id, coach.name, coach.title, coach.description, coach.price || 100, coach.currency || 'usd',
                                coach.coach_type, coach.coach_category, coach.coach_title, coach.coach_description, coach.icon_url], (err) => {
                                if (err) reject(err);
                                else resolve();
                            });
                        });
                    }
                } else if (quizExists) {
                    // Update existing quiz with coach info
                    console.log(`Updating existing quiz: ${coach.coach_title}`);
                    await updateQuizCoachInfo(
                        coach.id,
                        coach.coach_type,
                        coach.coach_category,
                        coach.coach_title,
                        coach.coach_description,
                        coach.icon_url
                    );
                }
                
                // Add images
                if (coach.images) {
                    for (const [index, image] of coach.images.entries()) {
                        await createQuizImage(
                            coach.id,
                            image.url,
                            image.type,
                            image.title,
                            image.description,
                            index
                        );
                        console.log(`  ✅ Added image: ${image.title}`);
                    }
                }
                
                console.log(`✅ Coach configured: ${coach.coach_title}`);
                
            } catch (error) {
                console.error(`❌ Error configuring coach ${coach.coach_title}:`, error);
            }
        }
        
        console.log('🎯 Sample coaches population completed!');
        
    } catch (error) {
        console.error('❌ Error populating sample coaches:', error);
        throw error;
    }
}

// Run the population if this file is executed directly
if (require.main === module) {
    populateSampleCoaches()
        .then(() => {
            console.log('✨ Sample coaches populated successfully!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('💥 Population failed:', error);
            process.exit(1);
        });
}

module.exports = { populateSampleCoaches };