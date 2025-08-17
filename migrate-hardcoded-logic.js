const db = require('./database');
const config = require('./config');

/**
 * Migration script to move hardcoded logic from JavaScript files to database tables
 * This ensures the quiz continues working the same way while making it configurable
 */

async function migrateHardcodedLogic() {
    console.log('🔄 Starting migration of hardcoded logic to database...');
    
    try {
        // 1. Migrate System Configuration (from config.js)
        console.log('📊 Migrating system configuration...');
        await migrateSystemConfig();
        
        // 2. Migrate Business Rules (scoring algorithm, tie-breaking, etc.)
        console.log('⚖️ Migrating business rules...');
        await migrateBusinessRules();
        
        // 3. Migrate Validation Rules (from quiz-service.js)
        console.log('✅ Migrating validation rules...');
        await migrateValidationRules();
        
        // 4. Set default question weights
        console.log('⚖️ Setting default question weights...');
        await migrateQuestionWeights();
        
        console.log('✅ Migration completed successfully!');
        console.log('🎯 All hardcoded logic has been moved to database tables.');
        console.log('📝 You can now edit these configurations through the admin interface.');
        
    } catch (error) {
        console.error('❌ Migration failed:', error);
        throw error;
    }
}

async function migrateSystemConfig() {
    const configs = [
        {
            configKey: 'quiz_price_cents',
            configType: 'pricing',
            configValue: JSON.stringify(config.QUIZ_PRICE.cents),
            description: 'Quiz price in cents (Stripe format)',
            isActive: true
        },
        {
            configKey: 'quiz_price_dollars',
            configType: 'pricing', 
            configValue: JSON.stringify(config.QUIZ_PRICE.dollars),
            description: 'Quiz price in dollars (display format)',
            isActive: true
        },
        {
            configKey: 'quiz_currency',
            configType: 'pricing',
            configValue: JSON.stringify(config.QUIZ_PRICE.currency),
            description: 'Currency code for payments',
            isActive: true
        },
        {
            configKey: 'quiz_price_display_text',
            configType: 'display',
            configValue: JSON.stringify(config.QUIZ_PRICE.displayText),
            description: 'Complete display text for payment buttons',
            isActive: true
        },
        {
            configKey: 'default_quiz_id',
            configType: 'calculation',
            configValue: JSON.stringify(1),
            description: 'Default quiz ID when none specified',
            isActive: true
        },
        {
            configKey: 'session_id_length',
            configType: 'calculation',
            configValue: JSON.stringify(32),
            description: 'Length of generated session IDs',
            isActive: true
        },
        {
            configKey: 'cache_enabled',
            configType: 'calculation',
            configValue: JSON.stringify(true),
            description: 'Enable quiz data caching for performance',
            isActive: true
        }
    ];
    
    for (const config of configs) {
        try {
            await db.createSystemConfig(
                config.configKey,
                config.configValue,
                config.configType,
                config.description,
                config.isActive
            );
            console.log(`  ✓ Added system config: ${config.configKey}`);
        } catch (error) {
            if (error.message.includes('duplicate key') || error.message.includes('UNIQUE constraint')) {
                console.log(`  ⚠️ System config already exists: ${config.configKey}`);
            } else {
                throw error;
            }
        }
    }
}

async function migrateBusinessRules() {
    const quizzes = await db.getAllQuizzes();
    
    for (const quiz of quizzes) {
        const businessRules = [
            {
                ruleName: 'Simple Addition Scoring',
                ruleCategory: 'scoring',
                ruleConfig: JSON.stringify({
                    algorithm: 'simple_addition',
                    description: 'Add personality weights from all answers',
                    implementation: 'sum_all_weights'
                }),
                priority: 10,
                isActive: true
            },
            {
                ruleName: 'Highest Score Wins',
                ruleCategory: 'scoring',
                ruleConfig: JSON.stringify({
                    algorithm: 'highest_score_wins',
                    description: 'Personality type with highest total score wins',
                    tie_breaking: 'first_found'
                }),
                priority: 9,
                isActive: true
            },
            {
                ruleName: 'Score Initialization',
                ruleCategory: 'scoring',
                ruleConfig: JSON.stringify({
                    initial_score: 0,
                    description: 'Initialize all personality type scores to 0'
                }),
                priority: 8,
                isActive: true
            },
            {
                ruleName: 'Complete All Questions Required',
                ruleCategory: 'completion',
                ruleConfig: JSON.stringify({
                    completion_rate: 100,
                    description: 'All questions must be answered',
                    allow_partial: false
                }),
                priority: 10,
                isActive: true
            },
            {
                ruleName: 'Result Display Format',
                ruleCategory: 'result_display',
                ruleConfig: JSON.stringify({
                    include_scores: true,
                    include_percentages: true,
                    include_calculation_details: true,
                    sort_by_score: true
                }),
                priority: 5,
                isActive: true
            }
        ];
        
        for (const rule of businessRules) {
            try {
                await db.createBusinessRule(
                    quiz.id,
                    rule.ruleName,
                    rule.ruleCategory,
                    rule.ruleConfig,
                    rule.priority,
                    rule.isActive
                );
                console.log(`  ✓ Added business rule for quiz ${quiz.id}: ${rule.ruleName}`);
            } catch (error) {
                console.log(`  ⚠️ Business rule may already exist: ${rule.ruleName}`);
            }
        }
    }
}

async function migrateValidationRules() {
    const quizzes = await db.getAllQuizzes();
    
    for (const quiz of quizzes) {
        const validationRules = [
            {
                ruleName: 'Answer Array Validation',
                ruleType: 'answer_validation',
                ruleConfig: JSON.stringify({
                    type: 'array_check',
                    description: 'Answers must be provided as an array',
                    validation: 'Array.isArray(answers)'
                }),
                errorMessage: 'Answers must be an array',
                isActive: true
            },
            {
                ruleName: 'Answer Count Validation',
                ruleType: 'completion_rate',
                ruleConfig: JSON.stringify({
                    type: 'count_check',
                    description: 'Number of answers must match number of questions',
                    validation: 'answers.length === questions.length'
                }),
                errorMessage: 'All questions must be answered',
                isActive: true
            },
            {
                ruleName: 'Answer Index Validation',
                ruleType: 'answer_validation',
                ruleConfig: JSON.stringify({
                    type: 'index_check',
                    description: 'Each answer must be a valid option index',
                    validation: 'typeof answerIndex === "number" && answerIndex >= 0 && answerIndex < question.options.length'
                }),
                errorMessage: 'Invalid answer option selected',
                isActive: true
            }
        ];
        
        for (const rule of validationRules) {
            try {
                await db.createValidationRule(
                    quiz.id,
                    rule.ruleName,
                    rule.ruleType,
                    rule.ruleConfig,
                    rule.errorMessage,
                    rule.isActive
                );
                console.log(`  ✓ Added validation rule for quiz ${quiz.id}: ${rule.ruleName}`);
            } catch (error) {
                console.log(`  ⚠️ Validation rule may already exist: ${rule.ruleName}`);
            }
        }
    }
}

async function migrateQuestionWeights() {
    const quizzes = await db.getAllQuizzes();
    
    for (const quiz of quizzes) {
        const questions = await db.getQuestionsByQuizId(quiz.id);
        
        for (const question of questions) {
            try {
                await db.createQuestionWeight(
                    quiz.id,
                    question.id,
                    1.0, // Default weight multiplier
                    'normal', // Default importance level
                    false // Not required by default
                );
                console.log(`  ✓ Added default weight for question ${question.id} in quiz ${quiz.id}`);
            } catch (error) {
                console.log(`  ⚠️ Question weight may already exist for question ${question.id}`);
            }
        }
    }
}

// Run migration if called directly
if (require.main === module) {
    migrateHardcodedLogic()
        .then(() => {
            console.log('\n🎉 Migration completed! The quiz will continue working exactly as before.');
            console.log('💡 You can now customize the behavior through the admin interface at:');
            console.log('   http://localhost:3000/admin/db-management.html');
            process.exit(0);
        })
        .catch((error) => {
            console.error('\n💥 Migration failed:', error);
            process.exit(1);
        });
}

module.exports = {
    migrateHardcodedLogic,
    migrateSystemConfig,
    migrateBusinessRules,
    migrateValidationRules,
    migrateQuestionWeights
};