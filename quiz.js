// Quiz data - loaded from API
let quizQuestions = [];
let quizMetadata = {};
let personalityTypes = [];
let QUIZ_ID = 1; // Default quiz ID - Relationship Personality Quiz
let availableCoaches = []; // Available coaches loaded from API

// Load coaches from API
async function loadCoaches() {
    try {
        const locale = window.i18n ? window.i18n.getLocale() : 'en_US';
        const headers = {
            'Accept-Language': locale.replace('_', '-')
        };
        
        const response = await fetch('/api/coaches', { headers });
        if (!response.ok) {
            throw new Error('Failed to load coaches');
        }
        availableCoaches = await response.json();
        console.log('Coaches loaded successfully:', availableCoaches.length);
        return true;
    } catch (error) {
        console.error('Error loading coaches:', error);
        showError('Failed to load coaches. Please refresh the page.');
        return false;
    }
}

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

// URL parameter detection
function getQuizIdFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    // Check for quiz parameter first, then coach for backward compatibility
    const quizId = urlParams.get('quiz') || urlParams.get('coach');
    return quizId ? parseInt(quizId) : null;
}

// Render coaches in the selection screen
async function renderCoaches() {
    const coachesContainer = document.getElementById('coaches-container');
    if (!coachesContainer) return;
    
    // Show loading state
    coachesContainer.innerHTML = '<div class="coaches-loading">Loading coaches...</div>';
    
    // Load coaches if not already loaded
    if (availableCoaches.length === 0) {
        const loaded = await loadCoaches();
        if (!loaded) return;
    }
    
    // Clear loading and render coaches
    coachesContainer.innerHTML = '';
    
    availableCoaches.forEach(coach => {
        const coachCard = document.createElement('div');
        coachCard.className = 'coach-card';
        coachCard.dataset.coachId = coach.id;
        
        // Get icon from coach data or use default based on category
        const iconMap = {
            'relationships': '💕',
            'career': '💼',
            'interviews': '🎯',
            'romance': '💖',
            'marriage': '💍'
        };
        const icon = iconMap[coach.coach_category] || '🌟';
        
        coachCard.innerHTML = `
            <div class="coach-icon">${icon}</div>
            <h3 class="coach-title">${coach.coach_title || coach.title}</h3>
            <p class="coach-description">${coach.coach_description || coach.description}</p>
            <span class="coach-category">${coach.coach_category}</span>
        `;
        
        coachCard.addEventListener('click', () => selectCoach(coach.id));
        coachesContainer.appendChild(coachCard);
    });
}

// Select a coach and start the quiz
function selectCoach(coachId) {
    // Use the coach ID as the quiz ID since each coach corresponds to a quiz
    QUIZ_ID = coachId;
    console.log('Coach selected:', coachId, 'Using quiz ID:', QUIZ_ID);
    
    // Update URL parameter to use quiz instead of coach
    const url = new URL(window.location);
    url.searchParams.set('quiz', coachId);
    url.searchParams.delete('coach'); // Remove old coach parameter
    window.history.replaceState({}, '', url);
    
    // Start the quiz with selected coach
    startQuizWithCoach();
}

// Start quiz with selected coach
async function startQuizWithCoach() {
    const loaded = await loadQuizData();
    if (loaded) {
        showScreen(quizScreen);
        loadQuestion();
    }
}

// DOM elements
const welcomeScreen = document.getElementById('welcome-screen');
const coachSelectionScreen = document.getElementById('coach-selection-screen');
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
    
    // Check if quiz is pre-selected via URL parameter
    const preSelectedQuizId = getQuizIdFromURL();
    
    if (preSelectedQuizId) {
        // Quiz pre-selected, load quiz directly
        QUIZ_ID = preSelectedQuizId;
        console.log('Pre-selected quiz:', preSelectedQuizId, 'Using quiz ID:', QUIZ_ID);
        const loaded = await loadQuizData();
        if (loaded) {
            showScreen(welcomeScreen);
        }
    } else {
        // No quiz pre-selected, load coaches and show coach selection screen
        console.log('No quiz parameter found, showing coach selection');
        const coachesLoaded = await loadCoaches();
        if (coachesLoaded) {
            showScreen(coachSelectionScreen);
            renderCoaches();
        } else {
            // Fallback to welcome screen if coaches fail to load
            showScreen(welcomeScreen);
        }
    }
}

// Show a specific screen and hide others
function showScreen(screenToShow) {
    const screens = [welcomeScreen, coachSelectionScreen, quizScreen, paymentScreen, resultsScreen];
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
        // Apply translation to back button
        const backText = window.i18n ? window.i18n.t('quiz.previousQuestion') : '← Back';
        backBtn.textContent = backText;
    } else {
        backBtn.style.display = 'none';
    }
    
    // Show/hide and enable/disable next button
    if (currentQuestionIndex < quizQuestions.length - 1) {
        nextBtn.style.display = 'inline-block';
        // Apply translation to next button
        const nextText = window.i18n ? window.i18n.t('quiz.nextQuestion') : 'Next →';
        nextBtn.textContent = nextText;
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
    const preSelectedQuizId = getQuizIdFromURL();
    
    if (preSelectedQuizId) {
        // Quiz pre-selected, start quiz directly
        if (quizQuestions.length > 0) {
            showScreen(quizScreen);
            loadQuestion();
        } else {
            const errorMsg = window.i18n ? window.i18n.t('errors.quiz_not_loaded') : 'Quiz data not loaded. Please refresh the page.';
            showError(errorMsg);
        }
    } else {
        // No quiz pre-selected, show coach selection screen
        showScreen(coachSelectionScreen);
        renderCoaches();
    }
});

// Coach selection screen event listeners
const backToWelcomeBtn = document.getElementById('back-to-welcome-btn');
if (backToWelcomeBtn) {
    backToWelcomeBtn.addEventListener('click', () => {
        showScreen(welcomeScreen);
    });
}

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