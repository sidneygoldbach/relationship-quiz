const { getCompleteQuizData, getPersonalityTypesByQuizId } = require('./database');
const { i18n } = require('./i18n');

class QuizService {
    constructor() {
        this.quizCache = new Map();
        this.cacheExpiry = 5 * 60 * 1000; // 5 minutes
    }

    // Get quiz data with caching
    async getQuizData(quizId = 1, locale = 'en_US') {
        const cacheKey = `quiz_${quizId}_${locale}`;
        const cached = this.quizCache.get(cacheKey);
        
        if (cached && Date.now() - cached.timestamp < this.cacheExpiry) {
            return cached.data;
        }

        try {
            const quizData = await getCompleteQuizData(quizId, locale);
            if (!quizData) {
                throw new Error(`Quiz with ID ${quizId} not found`);
            }

            // Data already comes translated from database based on locale
            
            // Ensure price information is available
            if (quizData.quiz && (!quizData.quiz.price || !quizData.quiz.currency)) {
                console.warn(`Quiz ${quizId} missing price information, using defaults`);
                quizData.quiz.price = quizData.quiz.price || 100; // Default 100 cents = $1.00
                quizData.quiz.currency = quizData.quiz.currency || 'usd';
            }

            // Cache the translated data
            this.quizCache.set(cacheKey, {
                data: quizData,
                timestamp: Date.now()
            });

            return quizData;
        } catch (error) {
            console.error('Error getting quiz data:', error);
            throw error;
        }
    }

    // Get questions for frontend
    async getQuizQuestions(quizId = 1, locale = 'en_US') {
        try {
            const quizData = await this.getQuizData(quizId, locale);
            
            return quizData.questions.map(question => ({
                id: question.id,
                question: question.question_text,
                category: question.category_name,
                options: question.options.map(option => ({
                    id: option.id,
                    text: option.option_text,
                    weights: this.parsePersonalityWeight(option.personality_weight)
                }))
            }));
        } catch (error) {
            console.error('Error getting quiz questions:', error);
            throw error;
        }
    }

    // Get personality types for frontend
    async getPersonalityTypes(quizId = 1, locale = 'en_US') {
        try {
            const quizData = await this.getQuizData(quizId, locale);
            
            return quizData.personalityTypes.map(type => ({
                id: type.id,
                type: type.type_name,
                key: type.type_key,
                description: type.description,
                personalityAdvice: type.personalityAdvice,
                relationshipAdvice: type.relationshipAdvice
            }));
        } catch (error) {
            console.error('Error getting personality types:', error);
            throw error;
        }
    }

    // Determine personality type based on answers
    async determinePersonalityType(answers, quizId = 1, sessionId = null, locale = 'en_US') {
        try {
            const quizData = await this.getQuizData(quizId, locale);
            const personalityScores = {};

            // Initialize scores for all personality types
            quizData.personalityTypes.forEach(type => {
                personalityScores[type.type_key] = 0;
            });

            // Calculate scores based on answers
            answers.forEach((answerIndex, questionIndex) => {
                const question = quizData.questions[questionIndex];
                if (question && question.options[answerIndex]) {
                    const option = question.options[answerIndex];
                    const weights = this.parsePersonalityWeight(option.personality_weight);
                    
                    // Add weights to personality scores
                    Object.entries(weights).forEach(([personalityKey, weight]) => {
                        if (personalityScores.hasOwnProperty(personalityKey)) {
                            personalityScores[personalityKey] += weight;
                        }
                    });
                }
            });

            // Find the personality type with the highest score
            let maxScore = 0;
            let winningPersonalityKey = null;
            
            console.log('DEBUG: Personality scores:', personalityScores);
            
            Object.entries(personalityScores).forEach(([key, score]) => {
                if (score > maxScore) {
                    maxScore = score;
                    winningPersonalityKey = key;
                }
            });

            console.log('DEBUG: Winning personality key:', winningPersonalityKey, 'Max score:', maxScore);
            console.log('DEBUG: Available personality types:', quizData.personalityTypes.map(t => t.type_key));

            // Get the full personality type data
            const personalityType = quizData.personalityTypes.find(
                type => type.type_key === winningPersonalityKey
            );

            if (!personalityType) {
                throw new Error('Could not determine personality type');
            }

            const result = {
                id: personalityType.id,
                type: personalityType.type_name,
                key: personalityType.type_key,
                description: personalityType.description,
                personalityAdvice: personalityType.personalityAdvice,
                relationshipAdvice: personalityType.relationshipAdvice,
                scores: personalityScores,
                maxScore,
                calculationDetails: {
                    totalQuestions: answers.length,
                    answeredQuestions: answers.filter(a => a !== null && a !== undefined).length,
                    personalityTypeDistribution: Object.entries(personalityScores)
                        .map(([key, score]) => ({ key, score, percentage: ((score / maxScore) * 100).toFixed(1) }))
                        .sort((a, b) => b.score - a.score)
                }
            };

            // If sessionId is provided, save detailed results to database
            if (sessionId) {
                try {
                    const { saveDetailedQuizResult } = require('./database');
                    await saveDetailedQuizResult(sessionId, quizId, answers, personalityScores, personalityType, maxScore);
                } catch (dbError) {
                    console.warn('Failed to save detailed quiz result to database:', dbError);
                    // Don't throw error here, just log it as the main calculation succeeded
                }
            }

            return result;
        } catch (error) {
            console.error('Error determining personality type:', error);
            throw error;
        }
    }

    // Parse personality weight from database (handles both JSON and string formats)
    parsePersonalityWeight(weight) {
        if (!weight) return {};
        
        if (typeof weight === 'string') {
            try {
                return JSON.parse(weight);
            } catch (e) {
                console.warn('Failed to parse personality weight:', weight);
                return {};
            }
        }
        
        return weight || {};
    }

    // Get quiz metadata
    async getQuizMetadata(quizId = 1, locale = 'en_US') {
        try {
            const quizData = await this.getQuizData(quizId, locale);
            
            return {
                id: quizData.quiz.id,
                name: quizData.quiz.name,
                title: quizData.quiz.title,
                description: quizData.quiz.description,
                price: quizData.quiz.price,
                currency: quizData.quiz.currency,
                questionCount: quizData.questions.length,
                personalityTypeCount: quizData.personalityTypes.length
            };
        } catch (error) {
            console.error('Error getting quiz metadata:', error);
            throw error;
        }
    }

    // Clear cache (useful for admin updates)
    clearCache(quizId = null, locale = null) {
        if (quizId && locale) {
            this.quizCache.delete(`quiz_${quizId}_${locale}`);
        } else if (quizId) {
            // Clear all locales for this quiz
            const keysToDelete = [];
            for (let key of this.quizCache.keys()) {
                if (key.startsWith(`quiz_${quizId}_`)) {
                    keysToDelete.push(key);
                }
            }
            keysToDelete.forEach(key => this.quizCache.delete(key));
        } else {
            this.quizCache.clear();
        }
    }

    // Validate quiz answers
    async validateAnswers(answers, quizId = 1, locale = 'en_US') {
        try {
            const quizData = await this.getQuizData(quizId, locale);
            
            if (!Array.isArray(answers)) {
                return { valid: false, error: 'Answers must be an array' };
            }
            
            if (answers.length !== quizData.questions.length) {
                return { 
                    valid: false, 
                    error: `Expected ${quizData.questions.length} answers, got ${answers.length}` 
                };
            }
            
            // Validate each answer
            for (let i = 0; i < answers.length; i++) {
                const answerIndex = answers[i];
                const question = quizData.questions[i];
                
                if (typeof answerIndex !== 'number' || answerIndex < 0 || answerIndex >= question.options.length) {
                    return { 
                        valid: false, 
                        error: `Invalid answer for question ${i + 1}: ${answerIndex}` 
                    };
                }
            }
            
            return { valid: true };
        } catch (error) {
            console.error('Error validating answers:', error);
            return { valid: false, error: 'Validation failed' };
        }
    }
}

// Create singleton instance
const quizService = new QuizService();

module.exports = quizService;