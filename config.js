// Global configuration file for the Relationship Quiz app
// This file centralizes all configurable values following best practices

// Quiz pricing configuration
const QUIZ_PRICE = {
    cents: 100,        // Amount in cents (Stripe format)
    dollars: 1.00,     // Amount in dollars (display format)
    currency: 'USD',   // Currency code
    displayText: 'Pay $1.00 USD'  // Complete display text for buttons
};

// Export for Node.js (server-side)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        QUIZ_PRICE
    };
}

// Export for browser (client-side)
if (typeof window !== 'undefined') {
    window.QUIZ_PRICE = QUIZ_PRICE;
}