// Quiz data - loaded from API
let quizQuestions = [];
let quizMetadata = {};
let personalityTypes = [];
const QUIZ_ID = 1; // Default quiz ID

// Load quiz data from API
async function loadQuizData() {
    try {
        // Get current locale from i18n system
        const locale = window.i18n ? window.i18n.getLocale() : 'en_US';
        const headers = {
            'Accept-Language': locale.replace('_', '-')
        };
        
        const response = await fetch(`/api/quiz/${QUIZ_ID}`, { headers });
        if (!response.ok) {
            throw new Error('Failed to load quiz data');
        }
        const data = await response.json();
        quizQuestions = data.questions;
        quizMetadata = data.quiz;
        
        // Load personality types
        const typesResponse = await fetch(`/api/quiz/${QUIZ_ID}/personality-types`, { headers });
        if (typesResponse.ok) {
            personalityTypes = await typesResponse.json();
        }
        
        console.log('Quiz data loaded successfully for locale:', locale);
        return true;
    } catch (error) {
        console.error('Error loading quiz data:', error);
        // Fallback to show error message
        showError('Failed to load quiz. Please refresh the page.');
        return false;
    }
}

// Show error message
function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    const errorTitle = window.i18n ? window.i18n.t('common.error') : 'Error';
    const reloadText = window.i18n ? window.i18n.t('common.reload_page') : 'Reload Page';
    errorDiv.innerHTML = `
        <div style="background: #fee; border: 1px solid #fcc; padding: 20px; margin: 20px; border-radius: 8px; color: #c33;">
            <h3>${errorTitle}</h3>
            <p>${message}</p>
            <button onclick="location.reload()" style="background: #c33; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">${reloadText}</button>
        </div>
    `;
    document.body.insertBefore(errorDiv, document.body.firstChild);
}

// DOM elements
const welcomeScreen = document.getElementById('welcome-screen');
const quizScreen = document.getElementById('quiz-screen');
const paymentScreen = document.getElementById('payment-screen');
const resultsScreen = document.getElementById('results-screen');
const startBtn = document.getElementById('start-btn');
const questionText = document.getElementById('question-text');
const optionsContainer = document.getElementById('options-container');
const progressBar = document.getElementById('progress');
const personalityResult = document.getElementById('personality-result');
const personalityAdvice = document.getElementById('personality-advice');
const relationshipAdvice = document.getElementById('relationship-advice');
const restartBtn = document.getElementById('restart-btn');
const backBtn = document.getElementById('back-btn');
const nextBtn = document.getElementById('next-btn');

// Quiz state
let currentQuestionIndex = 0;
let userAnswers = [];
let quizCompleted = false;
let userPersonalityType = null;

// Initialize the quiz
async function initQuiz() {
    currentQuestionIndex = 0;
    userAnswers = [];
    quizCompleted = false;
    userPersonalityType = null;
    
    // Load quiz data from API
    const loaded = await loadQuizData();
    if (loaded) {
        showScreen(welcomeScreen);
    }
}

// Show a specific screen and hide others
function showScreen(screenToShow) {
    const screens = [welcomeScreen, quizScreen, paymentScreen, resultsScreen];
    screens.forEach(screen => {
        if (screen === screenToShow) {
            screen.classList.add('active');
        } else {
            screen.classList.remove('active');
        }
    });
}

// Load a question
function loadQuestion() {
    if (currentQuestionIndex < quizQuestions.length) {
        const question = quizQuestions[currentQuestionIndex];
        questionText.textContent = question.question;
        
        // Clear previous options
        optionsContainer.innerHTML = '';
        
        // Create option buttons
        question.options.forEach((option, index) => {
            const button = document.createElement('button');
            button.className = 'option';
            button.textContent = option.text;
            button.onclick = () => selectOption(index);
            
            // If this question was already answered, highlight the selected option
            if (userAnswers[currentQuestionIndex] === index) {
                button.classList.add('selected');
            }
            
            optionsContainer.appendChild(button);
        });
        
        // Update progress bar
        const progress = ((currentQuestionIndex + 1) / quizQuestions.length) * 100;
        progressBar.style.width = progress + '%';
        
        // Update navigation buttons
        updateNavigationButtons();
    }
}

// Update navigation button visibility and state
function updateNavigationButtons() {
    // Show/hide back button
    if (currentQuestionIndex > 0) {
        backBtn.style.display = 'inline-block';
    } else {
        backBtn.style.display = 'none';
    }
    
    // Show/hide and enable/disable next button
    if (currentQuestionIndex < quizQuestions.length - 1) {
        nextBtn.style.display = 'inline-block';
        // Enable next button only if current question is answered
        if (userAnswers[currentQuestionIndex] !== undefined) {
            nextBtn.disabled = false;
        } else {
            nextBtn.disabled = true;
        }
    } else {
        // Last question - show finish button instead
        const finishText = window.i18n ? window.i18n.t('quiz.finish_quiz') : 'Finish Quiz';
        if (userAnswers[currentQuestionIndex] !== undefined) {
            nextBtn.style.display = 'inline-block';
            nextBtn.textContent = finishText;
            nextBtn.disabled = false;
        } else {
            nextBtn.style.display = 'inline-block';
            nextBtn.textContent = finishText;
            nextBtn.disabled = true;
        }
    }
}

// Handle option selection
function selectOption(optionIndex) {
    // Store the answer
    userAnswers[currentQuestionIndex] = optionIndex;
    
    // Highlight selected option
    const options = optionsContainer.querySelectorAll('.option');
    options.forEach((option, index) => {
        if (index === optionIndex) {
            option.classList.add('selected');
        } else {
            option.classList.remove('selected');
        }
    });
    
    // Update navigation buttons after selection
    updateNavigationButtons();
    
    // Auto-navigate to next question after a short delay
    setTimeout(() => {
        if (currentQuestionIndex < quizQuestions.length - 1) {
            // Move to next question
            currentQuestionIndex++;
            loadQuestion();
        } else {
            // Last question - complete quiz
            completeQuiz();
        }
    }, 500); // 500ms delay to allow user to see their selection
}

// Handle back button click
backBtn.addEventListener('click', () => {
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        loadQuestion();
    }
});

// Handle next button click
nextBtn.addEventListener('click', () => {
    if (currentQuestionIndex < quizQuestions.length - 1) {
        currentQuestionIndex++;
        loadQuestion();
    } else {
        // Last question - finish quiz
        completeQuiz();
    }
});

// Complete the quiz and show payment screen
async function completeQuiz() {
    quizCompleted = true;
    userPersonalityType = await determinePersonalityType();
    
    // Check for secret code
    const secretCode = document.getElementById('secret-code')?.value?.trim();
    if (secretCode === 'FREEPASS') {
        // Skip payment and go directly to results
        displayResults();
        return;
    }
    
    showScreen(paymentScreen);
}

// Determine personality type based on user answers
async function determinePersonalityType() {
    try {
        // Generate or get session ID for detailed scoring storage
        const sessionId = window.currentSessionId || generateSessionId();
        if (!window.currentSessionId) {
            window.currentSessionId = sessionId;
        }
        
        const response = await fetch(`/api/quiz/${QUIZ_ID}/calculate`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                answers: userAnswers,
                sessionId: sessionId
            })
        });
        
        if (!response.ok) {
            throw new Error('Failed to calculate personality type');
        }
        
        const result = await response.json();
        
        // Store detailed results for potential debugging or analytics
        if (result.calculationDetails) {
            console.log('Quiz Calculation Details:', result.calculationDetails);
        }
        
        return result;
    } catch (error) {
        console.error('Error determining personality type:', error);
        // Fallback to first personality type if API fails
        return personalityTypes[0] || {
            type: 'Unknown',
            description: 'Unable to determine personality type.',
            personalityAdvice: [],
            relationshipAdvice: []
        };
    }
}

// Generate a unique session ID
function generateSessionId() {
    return 'quiz_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}

// Display quiz results
function displayResults() {
    if (!userPersonalityType) return;
    
    personalityResult.textContent = `${userPersonalityType.type}: ${userPersonalityType.description}`;
    
    // Clear previous advice lists
    personalityAdvice.innerHTML = '';
    relationshipAdvice.innerHTML = '';
    
    // Add personality advice items
    userPersonalityType.personalityAdvice.forEach(advice => {
        const li = document.createElement('li');
        li.textContent = advice;
        personalityAdvice.appendChild(li);
    });
    
    // Add relationship advice items
    userPersonalityType.relationshipAdvice.forEach(advice => {
        const li = document.createElement('li');
        li.textContent = advice;
        relationshipAdvice.appendChild(li);
    });
    
    showScreen(resultsScreen);
}

// Event listeners
startBtn.addEventListener('click', () => {
    if (quizQuestions.length > 0) {
        showScreen(quizScreen);
        loadQuestion();
    } else {
        const errorMsg = window.i18n ? window.i18n.t('errors.quiz_not_loaded') : 'Quiz data not loaded. Please refresh the page.';
        showError(errorMsg);
    }
});

restartBtn.addEventListener('click', async () => {
    await initQuiz();
});

// Initialize the quiz when the page loads
document.addEventListener('DOMContentLoaded', async () => {
    await initQuiz();
});

// Update payment.js integration
window.addEventListener('load', () => {
    // Ensure payment module can access quiz state
    if (window.paymentModule) {
        window.paymentModule.setQuizModule(window.quizModule);
    }
});

// Export functions for payment.js to use
window.quizModule = {
    displayResults: displayResults,
    quizCompleted: () => quizCompleted,
    QUIZ_ID: QUIZ_ID
};