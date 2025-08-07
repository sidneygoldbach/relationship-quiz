// Quiz questions and options
const quizQuestions = [
    {
        question: "How do you typically handle conflicts in relationships?",
        options: [
            "I prefer to address issues immediately and directly.",
            "I need time to process before discussing the problem.",
            "I try to find a compromise that works for everyone.",
            "I sometimes avoid confrontation to keep the peace."
        ]
    },
    {
        question: "What's most important to you in a relationship?",
        options: [
            "Open and honest communication.",
            "Trust and loyalty.",
            "Emotional support and understanding.",
            "Growth and shared experiences."
        ]
    },
    {
        question: "How do you express affection to your partner?",
        options: [
            "Through physical touch and closeness.",
            "By giving gifts or doing thoughtful acts of service.",
            "With words of affirmation and compliments.",
            "By spending quality time together."
        ]
    },
    {
        question: "When making important decisions with a partner, you prefer to:",
        options: [
            "Take the lead and make decisions confidently.",
            "Discuss all options thoroughly before deciding together.",
            "Consider your partner's needs first.",
            "Be flexible and go with the flow."
        ]
    },
    {
        question: "How do you react when you feel emotionally hurt by someone close to you?",
        options: [
            "Express my feelings immediately and directly.",
            "Withdraw and process my emotions privately.",
            "Try to understand their perspective before reacting.",
            "Tend to forgive quickly and move forward."
        ]
    }
];

// Personality types based on answers
const personalityTypes = [
    {
        type: "The Communicator",
        description: "You value open and honest communication in relationships. You're direct about your needs and feelings, which helps prevent misunderstandings.",
        personalityAdvice: [
            "Practice active listening as much as you practice speaking.",
            "Remember that not everyone communicates as directly as you do.",
            "Balance honesty with tactfulness to avoid hurting others.",
            "Recognize when others need processing time before discussions.",
            "Your clarity is a strength that builds trust in relationships."
        ],
        relationshipAdvice: [
            "Create regular check-ins with partners to maintain open communication.",
            "When conflicts arise, focus on understanding before being understood.",
            "Validate others' feelings even when they differ from your perspective.",
            "Use 'I' statements rather than 'you' statements during difficult conversations.",
            "Appreciate different communication styles in your relationships."
        ]
    },
    {
        type: "The Nurturer",
        description: "You prioritize emotional support and understanding in relationships. Your empathetic nature makes others feel safe and valued.",
        personalityAdvice: [
            "Set healthy boundaries to avoid emotional burnout.",
            "Make self-care a priority alongside caring for others.",
            "Recognize when you're taking on others' emotional burdens.",
            "Allow yourself to receive support, not just give it.",
            "Your empathy is a gift that strengthens connections."
        ],
        relationshipAdvice: [
            "Communicate your own needs clearly rather than just focusing on others.",
            "Seek balance between giving and receiving in relationships.",
            "Find partners who appreciate your nurturing nature without taking advantage.",
            "Practice saying 'no' when necessary without feeling guilty.",
            "Build a support network beyond your primary relationship."
        ]
    },
    {
        type: "The Harmonizer",
        description: "You seek peace and balance in relationships. You're adaptable and willing to compromise to maintain harmony.",
        personalityAdvice: [
            "Recognize that some conflict is healthy and necessary.",
            "Stand firm on your core values even when it creates tension.",
            "Distinguish between healthy compromise and self-sacrifice.",
            "Practice expressing disagreement in constructive ways.",
            "Your flexibility is an asset in navigating relationship challenges."
        ],
        relationshipAdvice: [
            "Ensure your desire for harmony doesn't silence your authentic voice.",
            "Set clear expectations about your needs and boundaries.",
            "Look for partners who value compromise as much as you do.",
            "Address small issues before they become major problems.",
            "Celebrate the strength in your adaptability and peacemaking skills."
        ]
    },
    {
        type: "The Independent",
        description: "You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.",
        personalityAdvice: [
            "Balance independence with vulnerability for deeper connections.",
            "Share your internal process with trusted others.",
            "Recognize when self-reliance becomes a barrier to intimacy.",
            "Practice asking for help when needed.",
            "Your self-sufficiency is a strength that brings stability to relationships."
        ],
        relationshipAdvice: [
            "Communicate your need for space proactively, not reactively.",
            "Create rituals of connection to balance your independence.",
            "Look for partners who respect your autonomy without feeling threatened.",
            "Invest in interdependence alongside independence.",
            "Share your growth journey with those closest to you."
        ]
    },
    {
        type: "The Loyalist",
        description: "You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.",
        personalityAdvice: [
            "Ensure your loyalty to others doesn't override loyalty to yourself.",
            "Recognize that trust can be rebuilt after small breaches.",
            "Balance consistency with spontaneity and growth.",
            "Allow yourself and others room to evolve and change.",
            "Your steadfastness provides valuable security in relationships."
        ],
        relationshipAdvice: [
            "Communicate your expectations clearly to avoid disappointment.",
            "Practice forgiveness for minor transgressions.",
            "Look for partners who value commitment as much as you do.",
            "Build trust through small, consistent actions over time.",
            "Create space for both security and adventure in your relationships."
        ]
    }
];

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

// Quiz state
let currentQuestionIndex = 0;
let userAnswers = [];
let quizCompleted = false;
let userPersonalityType = null;

// Initialize the quiz
function initQuiz() {
    currentQuestionIndex = 0;
    userAnswers = [];
    quizCompleted = false;
    userPersonalityType = null;
    showScreen(welcomeScreen);
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
    const question = quizQuestions[currentQuestionIndex];
    questionText.textContent = question.question;
    
    // Clear previous options
    optionsContainer.innerHTML = '';
    
    // Create option elements
    question.options.forEach((option, index) => {
        const optionElement = document.createElement('div');
        optionElement.classList.add('option');
        optionElement.textContent = option;
        optionElement.addEventListener('click', () => selectOption(index));
        optionsContainer.appendChild(optionElement);
    });
    
    // Update progress bar
    const progress = ((currentQuestionIndex) / quizQuestions.length) * 100;
    progressBar.style.width = `${progress}%`;
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
    
    // Move to next question after a short delay
    setTimeout(() => {
        currentQuestionIndex++;
        
        if (currentQuestionIndex < quizQuestions.length) {
            loadQuestion();
        } else {
            completeQuiz();
        }
    }, 500);
}

// Complete the quiz and show payment screen
function completeQuiz() {
    quizCompleted = true;
    showScreen(paymentScreen);
    
    // Determine personality type based on answers
    determinePersonalityType();
}

// Determine personality type based on user answers
function determinePersonalityType() {
    // Simple algorithm to determine personality type based on most frequent answer pattern
    const answerCounts = [0, 0, 0, 0, 0];
    
    userAnswers.forEach(answer => {
        // Map answers to personality types (simplified approach)
        if (answer === 0) answerCounts[0]++; // Communicator
        else if (answer === 1) answerCounts[3]++; // Independent
        else if (answer === 2) answerCounts[1]++; // Nurturer
        else if (answer === 3) answerCounts[2]++; // Harmonizer
        
        // Additional logic to count for Loyalist type
        if (answer === 1 && userAnswers.includes(3)) answerCounts[4]++; // Loyalist
    });
    
    // Find the personality type with the highest count
    let maxCount = 0;
    let personalityIndex = 0;
    
    answerCounts.forEach((count, index) => {
        if (count > maxCount) {
            maxCount = count;
            personalityIndex = index;
        }
    });
    
    userPersonalityType = personalityTypes[personalityIndex];
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
    showScreen(quizScreen);
    loadQuestion();
});

restartBtn.addEventListener('click', () => {
    initQuiz();
});

// Initialize the quiz when the page loads
document.addEventListener('DOMContentLoaded', initQuiz);

// Export functions for payment.js to use
window.quizModule = {
    displayResults: displayResults,
    quizCompleted: () => quizCompleted
};