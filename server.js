// Simple Express server for handling Stripe payments
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { QUIZ_PRICE } = require('./config');
const db = require('./database');
const quizService = require('./quiz-service');
const { i18nMiddleware, i18n } = require('./i18n');

// Check for required environment variables
if (!process.env.STRIPE_SECRET_KEY) {
    console.warn('⚠️  STRIPE_SECRET_KEY not found in environment variables. Using test key.');
}
if (!process.env.STRIPE_PUBLISHABLE_KEY) {
    console.warn('⚠️  STRIPE_PUBLISHABLE_KEY not found in environment variables.');
}

const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY || 'sk_test_your_test_key_here'); // Use environment variable for Stripe secret key
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('.'));
app.use(express.json());
app.use(cors());
app.use(i18nMiddleware);

// Request logging middleware
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Serve the static files
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

// Serve admin dashboard
app.get('/admin', (req, res) => {
    res.sendFile(__dirname + '/admin.html');
});

// Serve database management system
app.get('/dbManagement', (req, res) => {
    res.sendFile(__dirname + '/db-management.html');
});

// Serve admin database management interface
app.get('/admin/db-management.html', (req, res) => {
    res.sendFile(__dirname + '/db-management.html');
});

// Serve admin static files
app.get('/admin/styles.css', (req, res) => {
    res.sendFile(__dirname + '/styles.css');
});

app.get('/admin/db-management.js', (req, res) => {
    res.sendFile(__dirname + '/db-management.js');
});

// I18n translations endpoint
app.get('/api/translations', (req, res) => {
    try {
        res.json({
            locale: req.locale,
            translations: req.translations,
            currencyInfo: req.currencyInfo
        });
    } catch (error) {
        console.error('Error getting translations:', error);
        res.status(500).json({ error: 'Failed to get translations' });
    }
});

// Supported locales endpoint
app.get('/api/supported-locales', async (req, res) => {
    try {
        const locales = await db.getSupportedLocales();
        res.json(locales);
    } catch (error) {
        console.error('Error getting supported locales:', error);
        res.status(500).json({ error: 'Failed to get supported locales' });
    }
});

// Stripe configuration endpoint
app.get('/stripe-config', (req, res) => {
    try {
        const publishableKey = process.env.STRIPE_PUBLISHABLE_KEY || 'pk_test_your_test_key_here';
        res.json({
            publishableKey: publishableKey,
            currencyInfo: req.currencyInfo
        });
    } catch (error) {
        console.error('Error getting Stripe config:', error);
        res.status(500).json({ error: 'Failed to get Stripe configuration' });
    }
});

// Create a payment intent
app.post('/create-payment-intent', async (req, res) => {
    try {
        const { sessionId } = req.body;
        console.log('Creating payment intent for session:', sessionId);
        
        // Get currency info based on locale
        const currencyInfo = req.currencyInfo;
        const amountInCents = Math.round(currencyInfo.amount * 100); // Convert to cents
        
        // Create a PaymentIntent with the amount, currency, and description
        const paymentIntent = await stripe.paymentIntents.create({
            amount: amountInCents,
            currency: currencyInfo.currency.toLowerCase(),
            description: req.t('payment.title') || 'Relationship Quiz Results',
            metadata: {
                sessionId: sessionId || 'unknown',
                locale: req.locale
            },
            automatic_payment_methods: {
                enabled: true,
            },
        });

        console.log('Payment intent created successfully:', paymentIntent.id);
        
        // Save payment record to database
        if (sessionId) {
            try {
                await db.savePayment(
                    sessionId,
                    paymentIntent.id,
                    amountInCents,
                    currencyInfo.currency.toLowerCase(),
                    'pending'
                );
                console.log('Payment record saved to database');
            } catch (dbError) {
                console.error('Error saving payment to database:', dbError);
                // Continue anyway - payment intent was created successfully
            }
        }
        
        // Send the client secret to the client
        res.json({
            clientSecret: paymentIntent.client_secret,
        });
    } catch (error) {
        console.error('❌ Error creating payment intent:', error);
        res.status(500).json({ error: error.message });
    }
});

// Get quiz data (questions and metadata)
app.get('/api/quiz/:quizId?', async (req, res) => {
    try {
        const quizId = parseInt(req.params.quizId) || 1;
        const locale = req.locale || 'en_US';
        
        // Get data directly from database with locale
        const questions = await quizService.getQuizQuestions(quizId, locale);
        const metadata = await quizService.getQuizMetadata(quizId, locale);
        
        res.json({
            quiz: metadata,
            questions: questions
        });
    } catch (error) {
        console.error('Error getting quiz data:', error);
        const errorMsg = req.t('errors.quiz_data_failed', 'Failed to get quiz data');
        res.status(500).json({ error: errorMsg });
    }
});

// Get personality types for a quiz
app.get('/api/quiz/:quizId/personality-types', async (req, res) => {
    try {
        const quizId = parseInt(req.params.quizId) || 1;
        const locale = req.locale || 'en_US';
        
        // Get data directly from database with locale
        const personalityTypes = await quizService.getPersonalityTypes(quizId, locale);
        
        res.json(personalityTypes);
    } catch (error) {
        console.error('Error getting personality types:', error);
        const errorMsg = req.t('errors.personality_types_failed', 'Failed to get personality types');
        res.status(500).json({ error: errorMsg });
    }
});

// Calculate quiz results
app.post('/api/quiz/:quizId/calculate', async (req, res) => {
    try {
        const quizId = parseInt(req.params.quizId) || 1;
        const { answers, sessionId } = req.body;
        const locale = req.locale || 'en_US';
        
        console.log('DEBUG: Calculate endpoint - locale:', locale, 'answers:', answers);
        
        if (!answers || !Array.isArray(answers)) {
            return res.status(400).json({ error: 'Answers array is required' });
        }
        
        // Validate answers
        const validation = await quizService.validateAnswers(answers, quizId, locale);
        console.log('DEBUG: Validation result:', validation);
        if (!validation.valid) {
            return res.status(400).json({ error: validation.error });
        }
        
        // Calculate personality type with optional sessionId for detailed storage
        const result = await quizService.determinePersonalityType(answers, quizId, sessionId, locale);
        
        res.json(result);
    } catch (error) {
        console.error('Error calculating quiz results:', error);
        res.status(500).json({ error: 'Failed to calculate quiz results' });
    }
});

// Save quiz results
app.post('/save-quiz-result', async (req, res) => {
    try {
        const { sessionId, email, answers, resultType, quizId, detailedScores } = req.body;
        
        if (!sessionId) {
            return res.status(400).json({ error: 'Session ID is required' });
        }
        
        console.log('Saving quiz result for session:', sessionId);
        
        // Get personality type ID from result type key
        let personalityTypeId = null;
        if (resultType && quizId) {
            try {
                const personalityTypes = await quizService.getPersonalityTypes(quizId);
                const personalityType = personalityTypes.find(type => type.key === resultType);
                personalityTypeId = personalityType ? personalityType.id : null;
            } catch (error) {
                console.warn('Could not find personality type ID for:', resultType);
            }
        }
        
        // Check if detailed scores were already saved during calculation
        let savedSession;
        try {
            const existingSession = await db.getQuizSessionWithScores(sessionId);
            if (existingSession && existingSession.detailed_scores) {
                // Session already has detailed scores, just update email if provided
                if (email) {
                    savedSession = await db.saveQuizSession(
                        sessionId, 
                        email, 
                        answers, 
                        resultType, 
                        quizId || 1, 
                        personalityTypeId,
                        existingSession.detailed_scores
                    );
                } else {
                    savedSession = existingSession;
                }
            } else {
                // Save with new detailed scores if provided
                savedSession = await db.saveQuizSession(
                    sessionId, 
                    email, 
                    answers, 
                    resultType, 
                    quizId || 1, 
                    personalityTypeId,
                    detailedScores
                );
            }
        } catch (error) {
            // Fallback to basic save if detailed score retrieval fails
            console.warn('Falling back to basic quiz session save:', error);
            savedSession = await db.saveQuizSession(
                sessionId, 
                email, 
                answers, 
                resultType, 
                quizId || 1, 
                personalityTypeId,
                detailedScores
            );
        }
        
        res.json({ 
            success: true, 
            sessionId: savedSession.session_id,
            id: savedSession.id,
            hasDetailedScores: !!savedSession.detailed_scores
        });
    } catch (error) {
        console.error('Error saving quiz result:', error);
        res.status(500).json({ error: 'Failed to save quiz result' });
    }
});

// Get quiz results
app.get('/quiz-results/:sessionId', async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        console.log('Retrieving quiz result for session:', sessionId);
        
        const session = await db.getQuizSession(sessionId);
        
        if (!session) {
            return res.status(404).json({ error: 'Quiz session not found' });
        }
        
        // Parse JSON answers if they exist
        if (session.quiz_answers && typeof session.quiz_answers === 'string') {
            session.quiz_answers = JSON.parse(session.quiz_answers);
        }
        
        res.json(session);
    } catch (error) {
        console.error('Error retrieving quiz result:', error);
        res.status(500).json({ error: 'Failed to retrieve quiz result' });
    }
});

// Get payment status
app.get('/payment-status/:sessionId', async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        console.log('Checking payment status for session:', sessionId);
        
        const payment = await db.getPaymentBySessionId(sessionId);
        const session = await db.getQuizSession(sessionId);
        
        res.json({
            paymentStatus: session?.payment_status || 'pending',
            paymentDetails: payment || null
        });
    } catch (error) {
        console.error('Error checking payment status:', error);
        res.status(500).json({ error: 'Failed to check payment status' });
    }
});

// Get quiz statistics (admin endpoint)
app.get('/admin/stats', async (req, res) => {
    try {
        const stats = await db.getQuizStats();
        res.json(stats);
    } catch (error) {
        console.error('Error getting quiz stats:', error);
        res.status(500).json({ error: 'Failed to get quiz statistics' });
    }
});

// Webhook endpoint for Stripe events
app.post('/webhook', express.raw({ type: 'application/json' }), async (req, res) => {
    const sig = req.headers['stripe-signature'];
    let event;

    try {
        // Verify the webhook signature
        event = stripe.webhooks.constructEvent(
            req.body,
            sig,
            process.env.STRIPE_WEBHOOK_SECRET || 'whsec_test_your_webhook_secret_here' // Use environment variable for webhook secret
        );
    } catch (err) {
        console.error('Webhook signature verification failed:', err.message);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    // Handle the event
    switch (event.type) {
        case 'payment_intent.succeeded':
            const paymentIntent = event.data.object;
            console.log('PaymentIntent was successful:', paymentIntent.id);
            
            try {
                // Update payment status in database
                await db.updatePaymentStatus(paymentIntent.id, 'succeeded');
                
                // Update quiz session payment status
                const sessionId = paymentIntent.metadata?.sessionId;
                if (sessionId) {
                    await db.updateQuizSessionPaymentStatus(sessionId, 'completed');
                    console.log(`Payment completed for session: ${sessionId}`);
                }
            } catch (dbError) {
                console.error('Error updating payment status in database:', dbError);
            }
            break;
            
        case 'payment_intent.payment_failed':
            const failedPaymentIntent = event.data.object;
            console.log('Payment failed:', failedPaymentIntent.id);
            
            try {
                // Update payment status in database
                await db.updatePaymentStatus(failedPaymentIntent.id, 'failed');
                
                // Update quiz session payment status
                const sessionId = failedPaymentIntent.metadata?.sessionId;
                if (sessionId) {
                    await db.updateQuizSessionPaymentStatus(sessionId, 'failed');
                    console.log(`Payment failed for session: ${sessionId}`);
                }
            } catch (dbError) {
                console.error('Error updating failed payment status in database:', dbError);
            }
            break;
            
        case 'payment_intent.canceled':
            const canceledPaymentIntent = event.data.object;
            console.log('Payment was canceled:', canceledPaymentIntent.id);
            
            try {
                await db.updatePaymentStatus(canceledPaymentIntent.id, 'canceled');
                
                const sessionId = canceledPaymentIntent.metadata?.sessionId;
                if (sessionId) {
                    await db.updateQuizSessionPaymentStatus(sessionId, 'canceled');
                }
            } catch (dbError) {
                console.error('Error updating canceled payment status in database:', dbError);
            }
            break;
            
        default:
            console.log(`Unhandled event type ${event.type}`);
    }

    // Return a 200 response to acknowledge receipt of the event
    res.send();
});

// Initialize database and start the server});

// Database Management Authentication
const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

// Default admin credentials (change in production)
const ADMIN_CREDENTIALS = {
    username: process.env.DB_ADMIN_USERNAME || 'admin',
    password: process.env.DB_ADMIN_PASSWORD || 'admin123'
};

// Authentication middleware
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'Access token required' });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ message: 'Invalid or expired token' });
        }
        req.user = user;
        next();
    });
}

// Database management login
app.post('/api/db-login', (req, res) => {
    const { username, password } = req.body;

    if (username === ADMIN_CREDENTIALS.username && password === ADMIN_CREDENTIALS.password) {
        const token = jwt.sign(
            { username: username, role: 'admin' },
            JWT_SECRET,
            { expiresIn: '24h' }
        );
        res.json({ token, message: 'Login successful' });
    } else {
        res.status(401).json({ message: 'Invalid credentials' });
    }
});

// Database management API endpoints
app.get('/api/db/quizzes', authenticateToken, async (req, res) => {
    try {
        const quizzes = await db.getAllQuizzes();
        res.json(quizzes);
    } catch (error) {
        console.error('Error fetching quizzes:', error);
        res.status(500).json({ message: 'Error fetching quizzes' });
    }
});

app.get('/api/db/questions', authenticateToken, async (req, res) => {
    try {
        const questions = await db.getAllQuestions();
        res.json(questions);
    } catch (error) {
        console.error('Error fetching questions:', error);
        res.status(500).json({ message: 'Error fetching questions' });
    }
});

app.get('/api/db/personality-types', authenticateToken, async (req, res) => {
    try {
        const types = await db.getAllPersonalityTypes();
        res.json(types);
    } catch (error) {
        console.error('Error fetching personality types:', error);
        res.status(500).json({ message: 'Error fetching personality types' });
    }
});

// Question Weights endpoints
app.get('/api/db/question-weights/:quizId', authenticateToken, async (req, res) => {
    try {
        const weights = await db.getQuestionWeightsByQuizId(req.params.quizId);
        res.json(weights);
    } catch (error) {
        console.error('Error fetching question weights:', error);
        res.status(500).json({ error: 'Failed to fetch question weights' });
    }
});

app.post('/api/db/question-weights', authenticateToken, async (req, res) => {
    try {
        const { quizId, questionId, weightMultiplier, importanceLevel, isRequired } = req.body;
        const result = await db.createQuestionWeight(quizId, questionId, weightMultiplier, importanceLevel, isRequired);
        res.json(result);
    } catch (error) {
        console.error('Error creating question weight:', error);
        res.status(500).json({ error: 'Failed to create question weight' });
    }
});

// Validation Rules endpoints
app.get('/api/db/validation-rules/:quizId', authenticateToken, async (req, res) => {
    try {
        const rules = await db.getValidationRulesByQuizId(req.params.quizId);
        res.json(rules);
    } catch (error) {
        console.error('Error fetching validation rules:', error);
        res.status(500).json({ error: 'Failed to fetch validation rules' });
    }
});

app.post('/api/db/validation-rules', authenticateToken, async (req, res) => {
    try {
        const { quizId, ruleName, ruleType, ruleConfig, errorMessage, isActive } = req.body;
        const result = await db.createValidationRule(quizId, ruleName, ruleType, ruleConfig, errorMessage, isActive);
        res.json(result);
    } catch (error) {
        console.error('Error creating validation rule:', error);
        res.status(500).json({ error: 'Failed to create validation rule' });
    }
});

// Business Rules endpoints
app.get('/api/db/business-rules/:quizId', authenticateToken, async (req, res) => {
    try {
        const rules = await db.getBusinessRulesByQuizId(req.params.quizId);
        res.json(rules);
    } catch (error) {
        console.error('Error fetching business rules:', error);
        res.status(500).json({ error: 'Failed to fetch business rules' });
    }
});

app.post('/api/db/business-rules', authenticateToken, async (req, res) => {
    try {
        const { quizId, ruleName, ruleCategory, ruleConfig, priority, isActive } = req.body;
        const result = await db.createBusinessRule(quizId, ruleName, ruleCategory, ruleConfig, priority, isActive);
        res.json(result);
    } catch (error) {
        console.error('Error creating business rule:', error);
        res.status(500).json({ error: 'Failed to create business rule' });
    }
});

// System Config endpoints
app.get('/api/db/system-config', authenticateToken, async (req, res) => {
    try {
        const configs = await db.getAllSystemConfig();
        res.json(configs);
    } catch (error) {
        console.error('Error fetching system config:', error);
        res.status(500).json({ error: 'Failed to fetch system config' });
    }
});

app.get('/api/db/system-config/type/:configType', authenticateToken, async (req, res) => {
    try {
        const configs = await db.getSystemConfigByType(req.params.configType);
        res.json(configs);
    } catch (error) {
        console.error('Error fetching system config by type:', error);
        res.status(500).json({ error: 'Failed to fetch system config by type' });
    }
});

app.post('/api/db/system-config', authenticateToken, async (req, res) => {
    try {
        const { configKey, configType, configValue, description, isActive } = req.body;
        const result = await db.createSystemConfig(configKey, configType, configValue, description, isActive);
        res.json(result);
    } catch (error) {
        console.error('Error creating system config:', error);
        res.status(500).json({ error: 'Failed to create system config' });
    }
});

// Advice endpoints
app.get('/api/advice', authenticateToken, async (req, res) => {
    try {
        const advice = await db.executeRawSQL('SELECT * FROM advice ORDER BY personality_type_id, advice_type, advice_order');
        res.json(advice);
    } catch (error) {
        console.error('Error fetching advice:', error);
        res.status(500).json({ error: 'Failed to fetch advice' });
    }
});

app.post('/api/advice', authenticateToken, async (req, res) => {
    try {
        const { personality_type_id, advice_type, advice_text, advice_order } = req.body;
        const result = await db.createAdvice(personality_type_id, advice_type, advice_text, advice_order);
        res.json(result);
    } catch (error) {
        console.error('Error creating advice:', error);
        res.status(500).json({ error: 'Failed to create advice' });
    }
});

app.put('/api/advice/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { personality_type_id, advice_type, advice_text, advice_order } = req.body;
        
        const query = `UPDATE advice SET personality_type_id = ${personality_type_id}, advice_type = '${advice_type}', advice_text = '${advice_text.replace(/'/g, "''")}', advice_order = ${advice_order} WHERE id = ${id}`;
        await db.executeRawSQL(query);
        
        res.json({ message: 'Advice updated successfully' });
    } catch (error) {
        console.error('Error updating advice:', error);
        res.status(500).json({ error: 'Failed to update advice' });
    }
});

app.delete('/api/advice/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        await db.executeRawSQL(`DELETE FROM advice WHERE id = ${id}`);
        res.json({ message: 'Advice deleted successfully' });
    } catch (error) {
        console.error('Error deleting advice:', error);
        res.status(500).json({ error: 'Failed to delete advice' });
    }
});

app.post('/api/db/execute-sql', authenticateToken, async (req, res) => {
    try {
        const { query } = req.body;
        
        // Basic security check - only allow SELECT, INSERT, UPDATE, DELETE
        const allowedOperations = /^\s*(SELECT|INSERT|UPDATE|DELETE)\s+/i;
        if (!allowedOperations.test(query)) {
            return res.status(400).json({ message: 'Only SELECT, INSERT, UPDATE, DELETE operations are allowed' });
        }
        
        // Prevent dangerous operations
        const dangerousPatterns = /(DROP|TRUNCATE|ALTER|CREATE|GRANT|REVOKE)/i;
        if (dangerousPatterns.test(query)) {
            return res.status(400).json({ message: 'Dangerous SQL operations are not allowed' });
        }
        
        const result = await db.executeRawSQL(query);
        res.json({ rows: result, message: 'Query executed successfully' });
    } catch (error) {
        console.error('Error executing SQL:', error);
        res.status(500).json({ message: error.message });
    }
});

const startServer = async () => {
    try {
        // Initialize database tables
        await db.initializeDatabase();
        console.log('✅ Database initialized successfully');
        
        // Initialize i18n system
        await i18n.initialize();
        console.log('🌐 I18n system initialized with locales:', i18n.supportedLocales.join(', '));
        
        // Start the server
        app.listen(PORT, () => {
            console.log(`🚀 Server running on port ${PORT}`);
            console.log(`🌐 Open http://localhost:${PORT} in your browser`);
            console.log('📊 Admin stats available at: http://localhost:' + PORT + '/admin/stats');
        });
    } catch (error) {
        console.error('❌ Failed to start server:', error);
        console.error('Make sure PostgreSQL is running and database credentials are correct');
        process.exit(1);
    }
};

// Start the application
startServer();