const { initializeDatabase, testConnection, createQuiz, createCategory, createQuestion, createAnswerOption, createPersonalityType, createAdvice } = require('./database');

// Original hardcoded quiz data from quiz.js
const quizQuestions = [
    {
        question: "How do you typically handle conflicts in relationships?",
        category: "conflict handling",
        options: [
            { text: "I prefer to address issues immediately and directly.", weights: { communicator: 3, independent: 1 } },
            { text: "I need time to process before discussing the problem.", weights: { independent: 3, loyalist: 1 } },
            { text: "I try to find a compromise that works for everyone.", weights: { harmonizer: 3, nurturer: 1 } },
            { text: "I sometimes avoid confrontation to keep the peace.", weights: { harmonizer: 2, nurturer: 2 } }
        ]
    },
    {
        question: "What's most important to you in a relationship?",
        category: "relationship priorities",
        options: [
            { text: "Open and honest communication.", weights: { communicator: 3, loyalist: 1 } },
            { text: "Trust and loyalty.", weights: { loyalist: 3, communicator: 1 } },
            { text: "Emotional support and understanding.", weights: { nurturer: 3, harmonizer: 1 } },
            { text: "Growth and shared experiences.", weights: { independent: 3, communicator: 1 } }
        ]
    },
    {
        question: "How do you express affection to your partner?",
        category: "affection expression",
        options: [
            { text: "Through physical touch and closeness.", weights: { nurturer: 2, harmonizer: 2 } },
            { text: "By giving gifts or doing thoughtful acts of service.", weights: { loyalist: 3, nurturer: 1 } },
            { text: "With words of affirmation and compliments.", weights: { communicator: 3, nurturer: 1 } },
            { text: "By spending quality time together.", weights: { harmonizer: 3, loyalist: 1 } }
        ]
    },
    {
        question: "When making important decisions with a partner, you prefer to:",
        category: "decision-making",
        options: [
            { text: "Take the lead and make decisions confidently.", weights: { communicator: 2, independent: 2 } },
            { text: "Discuss all options thoroughly before deciding together.", weights: { communicator: 2, loyalist: 2 } },
            { text: "Consider your partner's needs first.", weights: { nurturer: 3, harmonizer: 1 } },
            { text: "Be flexible and go with the flow.", weights: { harmonizer: 3, independent: 1 } }
        ]
    },
    {
        question: "How do you react when you feel emotionally hurt by someone close to you?",
        category: "emotional reactions",
        options: [
            { text: "Express my feelings immediately and directly.", weights: { communicator: 3, independent: 1 } },
            { text: "Withdraw and process my emotions privately.", weights: { independent: 3, loyalist: 1 } },
            { text: "Try to understand their perspective before reacting.", weights: { nurturer: 2, harmonizer: 2 } },
            { text: "Tend to forgive quickly and move forward.", weights: { harmonizer: 2, loyalist: 2 } }
        ]
    }
];

const personalityTypes = [
    {
        type: "The Communicator",
        key: "communicator",
        description: "You value open and honest communication in relationships. You're direct about your needs and feelings, which helps prevent misunderstandings.",
        personalityAdvice: [
            "Practice active listening as much as you practice speaking.",
            "Remember that not everyone communicates as directly as you do.",
            "Balance honesty with tactfulness to avoid hurting others.",
            "Recognize when others need processing time before discussions.",
            "Your clarity is a strength that builds trust in relationships."
        ],
        relationshipAdvice: [
            "Create regular check-ins with partners to maintain open communication.",
            "When conflicts arise, focus on understanding before being understood.",
            "Validate others' feelings even when they differ from your perspective.",
            "Use 'I' statements rather than 'you' statements during difficult conversations.",
            "Appreciate different communication styles in your relationships."
        ]
    },
    {
        type: "The Nurturer",
        key: "nurturer",
        description: "You prioritize emotional support and understanding in relationships. Your empathetic nature makes others feel safe and valued.",
        personalityAdvice: [
            "Set healthy boundaries to avoid emotional burnout.",
            "Make self-care a priority alongside caring for others.",
            "Recognize when you're taking on others' emotional burdens.",
            "Allow yourself to receive support, not just give it.",
            "Your empathy is a gift that strengthens connections."
        ],
        relationshipAdvice: [
            "Communicate your own needs clearly rather than just focusing on others.",
            "Seek balance between giving and receiving in relationships.",
            "Find partners who appreciate your nurturing nature without taking advantage.",
            "Practice saying 'no' when necessary without feeling guilty.",
            "Build a support network beyond your primary relationship."
        ]
    },
    {
        type: "The Harmonizer",
        key: "harmonizer",
        description: "You seek peace and balance in relationships. You're adaptable and willing to compromise to maintain harmony.",
        personalityAdvice: [
            "Recognize that some conflict is healthy and necessary.",
            "Stand firm on your core values even when it creates tension.",
            "Distinguish between healthy compromise and self-sacrifice.",
            "Practice expressing disagreement in constructive ways.",
            "Your flexibility is an asset in navigating relationship challenges."
        ],
        relationshipAdvice: [
            "Ensure your desire for harmony doesn't silence your authentic voice.",
            "Set clear expectations about your needs and boundaries.",
            "Look for partners who value compromise as much as you do.",
            "Address small issues before they become major problems.",
            "Celebrate the strength in your adaptability and peacemaking skills."
        ]
    },
    {
        type: "The Independent",
        key: "independent",
        description: "You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.",
        personalityAdvice: [
            "Balance independence with vulnerability for deeper connections.",
            "Share your internal process with trusted others.",
            "Recognize when self-reliance becomes a barrier to intimacy.",
            "Practice asking for help when needed.",
            "Your self-sufficiency is a strength that brings stability to relationships."
        ],
        relationshipAdvice: [
            "Communicate your need for space proactively, not reactively.",
            "Create rituals of connection to balance your independence.",
            "Look for partners who respect your autonomy without feeling threatened.",
            "Invest in interdependence alongside independence.",
            "Share your growth journey with those closest to you."
        ]
    },
    {
        type: "The Loyalist",
        key: "loyalist",
        description: "You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.",
        personalityAdvice: [
            "Ensure your loyalty to others doesn't override loyalty to yourself.",
            "Recognize that trust can be rebuilt after small breaches.",
            "Balance consistency with spontaneity and growth.",
            "Allow yourself and others room to evolve and change.",
            "Your steadfastness provides valuable security in relationships."
        ],
        relationshipAdvice: [
            "Communicate your expectations clearly to avoid disappointment.",
            "Practice forgiveness for minor transgressions.",
            "Look for partners who value commitment as much as you do.",
            "Build trust through small, consistent actions over time.",
            "Create space for both security and adventure in your relationships."
        ]
    }
];

async function migrateQuizData() {
    try {
        console.log('🚀 Starting quiz data migration...');
        
        // Test database connection
        const connected = await testConnection();
        if (!connected) {
            throw new Error('Database connection failed');
        }
        
        // Initialize database tables
        await initializeDatabase();
        console.log('✅ Database tables initialized');
        
        // Create the main quiz
        const quiz = await createQuiz(
            'relationship-quiz',
            'Relationship Personality Quiz',
            'Discover insights about your relationship style and get personalized advice!',
            'Your Relationship Type', // result_title
            100, // $1.00
            'usd'
        );
        console.log('✅ Created main quiz:', quiz.name);
        
        // Create categories
        const categories = {};
        const categoryNames = [...new Set(quizQuestions.map(q => q.category))];
        
        for (const categoryName of categoryNames) {
            const category = await createCategory(
                categoryName,
                `Questions related to ${categoryName}`
            );
            categories[categoryName] = category;
            console.log('✅ Created category:', categoryName);
        }
        
        // Create personality types and their advice
        const personalityTypeMap = {};
        for (const [index, typeData] of personalityTypes.entries()) {
            const personalityType = await createPersonalityType(
                quiz.id,
                typeData.type,
                typeData.key,
                typeData.description
            );
            personalityTypeMap[typeData.key] = personalityType;
            
            // Add personality advice
            for (const [adviceIndex, advice] of typeData.personalityAdvice.entries()) {
                await createAdvice(
          personalityType.id,
          'personality',
          advice,
          adviceIndex
        );
            }
            
            // Add relationship advice
            for (const [adviceIndex, advice] of typeData.relationshipAdvice.entries()) {
                await createAdvice(
          personalityType.id,
          'relationship',
          advice,
          adviceIndex
        );
            }
            
            console.log('✅ Created personality type:', typeData.type);
        }
        
        // Create questions and answer options
        for (const [questionIndex, questionData] of quizQuestions.entries()) {
            const question = await createQuestion(
                quiz.id,
                categories[questionData.category].id,
                questionData.question,
                questionIndex
            );
            
            // Create answer options
            for (const [optionIndex, option] of questionData.options.entries()) {
                await createAnswerOption(
                    question.id,
                    option.text,
                    optionIndex,
                    option.weights
                );
            }
            
            console.log('✅ Created question:', questionData.question.substring(0, 50) + '...');
        }
        
        console.log('🎉 Quiz data migration completed successfully!');
        console.log('📊 Summary:');
        console.log(`   - 1 quiz created`);
        console.log(`   - ${categoryNames.length} categories created`);
        console.log(`   - ${personalityTypes.length} personality types created`);
        console.log(`   - ${quizQuestions.length} questions created`);
        console.log(`   - ${quizQuestions.reduce((sum, q) => sum + q.options.length, 0)} answer options created`);
        console.log(`   - ${personalityTypes.reduce((sum, p) => sum + p.personalityAdvice.length + p.relationshipAdvice.length, 0)} advice items created`);
        
    } catch (error) {
        console.error('❌ Migration failed:', error);
        throw error;
    }
}

// Run migration if this file is executed directly
if (require.main === module) {
    migrateQuizData()
        .then(() => {
            console.log('Migration completed successfully');
            process.exit(0);
        })
        .catch((error) => {
            console.error('Migration failed:', error);
            process.exit(1);
        });
}

module.exports = { migrateQuizData };