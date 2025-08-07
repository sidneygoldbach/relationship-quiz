// Stripe payment integration
let stripe;
let elements;
let paymentIntentId;

// Initialize Stripe elements when the payment screen is shown
document.addEventListener('DOMContentLoaded', () => {
    // Initialize Stripe with your publishable key
    // Note: In a real application, you would get this key from your server
    // This is a placeholder and needs to be replaced with a real Stripe publishable key
    initializeStripe('pk_test_your_stripe_publishable_key_here');
});

// Initialize Stripe with the publishable key
async function initializeStripe(publishableKey) {
    stripe = Stripe(publishableKey);
    
    // Listen for the payment screen to become active
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.target.id === 'payment-screen' && 
                mutation.target.classList.contains('active')) {
                createPaymentForm();
            }
        });
    });
    
    observer.observe(document.getElementById('payment-screen'), {
        attributes: true,
        attributeFilter: ['class']
    });
}

// Create the payment form
async function createPaymentForm() {
    try {
        // In a real application, you would make an API call to your server to create a PaymentIntent
        // and return the client secret. This is a simplified example.
        const clientSecret = await createPaymentIntent();
        
        // Create the payment form elements
        elements = stripe.elements({
            clientSecret,
            appearance: {
                theme: 'stripe',
                variables: {
                    colorPrimary: '#1877f2',
                }
            }
        });
        
        // Create the payment element
        const paymentElement = elements.create('payment');
        paymentElement.mount('#payment-element');
        
        // Handle form submission
        const form = document.getElementById('payment-form');
        form.addEventListener('submit', handlePaymentSubmission);
    } catch (error) {
        showPaymentMessage('Failed to load payment form. Please try again.');
        console.error('Payment form creation error:', error);
    }
}

// Create a PaymentIntent by calling our server API
async function createPaymentIntent() {
    try {
        const response = await fetch('/create-payment-intent', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({}),
        });
        
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        
        const data = await response.json();
        return data.clientSecret;
    } catch (error) {
        console.error('Error creating payment intent:', error);
        throw error;
    }
}

// Handle payment form submission
async function handlePaymentSubmission(e) {
    e.preventDefault();
    
    const submitButton = document.getElementById('submit-payment');
    submitButton.disabled = true;
    submitButton.textContent = 'Processing...';
    
    try {
        // Confirm the payment with Stripe
        const { error, paymentIntent } = await stripe.confirmPayment({
            elements,
            confirmParams: {
                return_url: window.location.href + '?payment_success=true',
            },
            redirect: 'if_required'
        });
        
        if (error) {
            throw new Error(error.message || 'Payment failed');
        } else if (paymentIntent && paymentIntent.status === 'succeeded') {
            paymentIntentId = paymentIntent.id;
            handleSuccessfulPayment();
        } else {
            // Payment requires additional action or is processing
            showPaymentMessage('Payment is processing. Please wait...', 'info');
        }
    } catch (error) {
        showPaymentMessage('Payment failed: ' + error.message);
        console.error('Payment error:', error);
    } finally {
        submitButton.disabled = false;
        submitButton.textContent = 'Pay $1.00 USD';
    }
}

// Handle successful payment
function handleSuccessfulPayment() {
    showPaymentMessage('Payment successful! Loading your results...', 'success');
    
    // Show results after a short delay
    setTimeout(() => {
        // Display the quiz results
        window.quizModule.displayResults();
    }, 1500);
}

// Show payment message
function showPaymentMessage(message, type = 'error') {
    const messageElement = document.getElementById('payment-message');
    messageElement.textContent = message;
    
    // Set color based on message type
    switch (type) {
        case 'success':
            messageElement.style.color = '#4CAF50'; // Green
            break;
        case 'info':
            messageElement.style.color = '#2196F3'; // Blue
            break;
        case 'warning':
            messageElement.style.color = '#FF9800'; // Orange
            break;
        case 'error':
        default:
            messageElement.style.color = '#e53935'; // Red
            break;
    }
}

// In a real application, you would also implement:
// 1. Server-side API to create PaymentIntents
// 2. Webhook handling for payment events
// 3. Database to store payment status
// 4. Error handling and recovery