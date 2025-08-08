// Simple Express server for handling Stripe payments
require('dotenv').config();
const express = require('express');
const cors = require('cors');

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
        console.log('Creating payment intent...');
        
        // Create a PaymentIntent with the amount, currency, and description
        const paymentIntent = await stripe.paymentIntents.create({
            amount: 100, // Amount in cents (100 cents = $1.00)
            currency: 'usd',
            description: 'Relationship Quiz Results',
            automatic_payment_methods: {
                enabled: true,
            },
        });

        console.log('Payment intent created successfully:', paymentIntent.id);
        
        // Send the client secret to the client
        res.json({
            clientSecret: paymentIntent.client_secret,
        });
    } catch (error) {
        console.error('❌ Error creating payment intent:', error);
        res.status(500).json({ error: error.message });
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
            // Here you would update your database to mark the user as paid
            break;
        case 'payment_intent.payment_failed':
            const failedPaymentIntent = event.data.object;
            console.log('Payment failed:', failedPaymentIntent.id);
            // Here you would handle the failed payment
            break;
        default:
            console.log(`Unhandled event type ${event.type}`);
    }

    // Return a 200 response to acknowledge receipt of the event
    res.send();
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Open http://localhost:${PORT} in your browser`);
});