// Simple Express server for handling Stripe payments
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { QUIZ_PRICE } = require('./config');
const db = require('./database');

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

// Stripe configuration endpoint
app.get('/stripe-config', (req, res) => {
    try {
        const publishableKey = process.env.STRIPE_PUBLISHABLE_KEY || 'pk_test_your_test_key_here';
        res.json({
            publishableKey: publishableKey
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
        
        // Create a PaymentIntent with the amount, currency, and description
        const paymentIntent = await stripe.paymentIntents.create({
            amount: QUIZ_PRICE.cents, // Amount in cents from config
            currency: QUIZ_PRICE.currency.toLowerCase(),
            description: 'Relationship Quiz Results',
            metadata: {
                sessionId: sessionId || 'unknown'
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
                    QUIZ_PRICE.cents,
                    QUIZ_PRICE.currency.toLowerCase(),
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

// Save quiz results
app.post('/save-quiz-result', async (req, res) => {
    try {
        const { sessionId, email, answers, resultType } = req.body;
        
        if (!sessionId) {
            return res.status(400).json({ error: 'Session ID is required' });
        }
        
        console.log('Saving quiz result for session:', sessionId);
        
        const savedSession = await db.saveQuizSession(sessionId, email, answers, resultType);
        
        res.json({ 
            success: true, 
            sessionId: savedSession.session_id,
            id: savedSession.id 
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

// Initialize database and start the server
const startServer = async () => {
    try {
        // Initialize database tables
        await db.initializeDatabase();
        console.log('✅ Database initialized successfully');
        
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