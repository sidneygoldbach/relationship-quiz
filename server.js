// Simple Express server for handling Stripe payments
const express = require('express');
const cors = require('cors');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY || 'sk_test_your_test_key_here'); // Use environment variable for Stripe secret key
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('.'));
app.use(express.json());
app.use(cors());

// Serve the static files
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

// Create a payment intent
app.post('/create-payment-intent', async (req, res) => {
    try {
        // Create a PaymentIntent with the amount, currency, and description
        const paymentIntent = await stripe.paymentIntents.create({
            amount: 100, // Amount in cents (100 cents = $1.00)
            currency: 'usd',
            description: 'Relationship Quiz Results',
            automatic_payment_methods: {
                enabled: true,
            },
        });

        // Send the client secret to the client
        res.json({
            clientSecret: paymentIntent.client_secret,
        });
    } catch (error) {
        console.error('Error creating payment intent:', error);
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