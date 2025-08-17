// Stripe payment integration
let stripe;
let elements;
let paymentIntentId;
let quizModule = null;
let currentQuizId = 1; // Will be set by quiz module

// Initialize Stripe elements when the payment screen is shown
document.addEventListener('DOMContentLoaded', async () => {
    try {
        // Get Stripe publishable key from server
        const publishableKey = await getStripePublishableKey();
        initializeStripe(publishableKey);
    } catch (error) {
        console.error('Failed to initialize Stripe:', error);
        const errorMsg = window.i18n ? window.i18n.t('errors.payment_init_failed') : 'Failed to initialize payment system. Please refresh the page.';
        showPaymentMessage(errorMsg);
    }
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

// Get Stripe publishable key from server
async function getStripePublishableKey() {
    try {
        const response = await fetch('/stripe-config');
        if (!response.ok) {
            throw new Error('Failed to get Stripe configuration');
        }
        const config = await response.json();
        return config.publishableKey;
    } catch (error) {
        console.error('Error getting Stripe config:', error);
        throw error;
    }
}

// Create a PaymentIntent by calling our server API
async function createPaymentIntent() {
    try {
        // Generate session ID for this quiz attempt
        const sessionId = generateSessionId();
        
        const response = await fetch('/create-payment-intent', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                sessionId: sessionId,
                quizId: currentQuizId
            }),
        });
        
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        
        const data = await response.json();
        
        // Store session ID for later use
        window.currentSessionId = sessionId;
        
        return data.clientSecret;
    } catch (error) {
        console.error('Error creating payment intent:', error);
        throw error;
    }
}

// Generate a unique session ID
function generateSessionId() {
    return 'quiz_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// Handle payment form submission
async function handlePaymentSubmission(e) {
    e.preventDefault();
    
    const submitButton = document.getElementById('submit-payment');
    submitButton.disabled = true;
    const processingText = window.i18n ? window.i18n.t('payment.processing') : 'Processing...';
    submitButton.textContent = processingText;
    
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
            const processingMsg = window.i18n ? window.i18n.t('payment.processing_wait') : 'Payment is processing. Please wait...';
            showPaymentMessage(processingMsg, 'info');
        }
    } catch (error) {
        const failedMsg = window.i18n ? window.i18n.t('payment.failed') : 'Payment failed';
        showPaymentMessage(failedMsg + ': ' + error.message);
        console.error('Payment error:', error);
    } finally {
        submitButton.disabled = false;
        const payText = window.i18n && window.i18n.currencyInfo ? 
            `${window.i18n.t('payment.pay')} ${window.i18n.currencyInfo.symbol}${window.i18n.currencyInfo.amount} ${window.i18n.currencyInfo.code}` : 
            (window.QUIZ_PRICE ? window.QUIZ_PRICE.displayText : 'Pay $1.00 USD');
        submitButton.textContent = payText;
    }
}

// Handle successful payment
async function handleSuccessfulPayment() {
    const successMsg = window.i18n ? window.i18n.t('payment.success_saving') : 'Payment successful! Saving your results...';
    showPaymentMessage(successMsg, 'success');
    
    try {
        // Save quiz results to database
        await saveQuizResults();
        
        // Show results after a short delay
        setTimeout(() => {
            // Display the quiz results
            if (window.quizModule) {
                window.quizModule.displayResults();
            }
        }, 1500);
    } catch (error) {
        console.error('Error saving quiz results:', error);
        const warningMsg = window.i18n ? window.i18n.t('payment.success_save_failed') : 'Payment successful, but failed to save results. Please contact support.';
        showPaymentMessage(warningMsg, 'warning');
        
        // Still show results even if saving failed
        setTimeout(() => {
            if (window.quizModule) {
                window.quizModule.displayResults();
            }
        }, 1500);
    }
}

// Save quiz results to database
async function saveQuizResults() {
    if (!window.currentSessionId || !window.userAnswers || !window.userPersonalityType) {
        throw new Error('Missing quiz data for saving results');
    }
    
    try {
        const response = await fetch('/save-quiz-result', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                sessionId: window.currentSessionId,
                email: '', // Could be collected from a form if needed
                answers: window.userAnswers,
                resultType: window.userPersonalityType.key || window.userPersonalityType.type,
                quizId: currentQuizId
            }),
        });
        
        if (!response.ok) {
            throw new Error('Failed to save quiz results');
        }
        
        const result = await response.json();
        console.log('Quiz results saved successfully:', result);
        return result;
    } catch (error) {
        console.error('Error saving quiz results:', error);
        throw error;
    }
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

// Set quiz module reference
function setQuizModule(module) {
    quizModule = module;
    if (module && module.QUIZ_ID) {
        currentQuizId = module.QUIZ_ID;
    }
}

// Export payment module functions
window.paymentModule = {
    setQuizModule: setQuizModule,
    handleSuccessfulPayment: handleSuccessfulPayment,
    saveQuizResults: saveQuizResults
};

// In a real application, you would also implement:
// 1. Server-side API to create PaymentIntents ✓
// 2. Webhook handling for payment events ✓
// 3. Database to store payment status ✓
// 4. Error handling and recovery ✓