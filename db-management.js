// Database Management System JavaScript

// DOM elements
const loginScreen = document.getElementById('login-screen');
const dbManagement = document.getElementById('db-management');
const loginForm = document.getElementById('login-form');
const loginError = document.getElementById('login-error');
const logoutBtn = document.getElementById('logout-btn');
const tabBtns = document.querySelectorAll('.tab-btn');
const tabContents = document.querySelectorAll('.tab-content');

// Authentication state
let isAuthenticated = false;
let authToken = null;

// Initialize the application
document.addEventListener('DOMContentLoaded', function() {
    checkAuthStatus();
    setupEventListeners();
});

// Check if user is already authenticated
function checkAuthStatus() {
    const token = localStorage.getItem('dbAuthToken');
    if (token) {
        authToken = token;
        showDashboard();
    } else {
        showLogin();
    }
}

// Setup event listeners
function setupEventListeners() {
    // Login form submission
    loginForm.addEventListener('submit', handleLogin);
    
    // Logout button
    logoutBtn.addEventListener('click', handleLogout);
    
    // Tab switching
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => switchTab(btn.dataset.tab));
    });
}

// Handle login
async function handleLogin(e) {
    e.preventDefault();
    
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    
    try {
        const response = await fetch('/api/db-login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            authToken = data.token;
            localStorage.setItem('dbAuthToken', authToken);
            showDashboard();
            loadInitialData();
        } else {
            showError(data.message || 'Login failed');
        }
    } catch (error) {
        showError('Connection error. Please try again.');
    }
}

// Handle logout
function handleLogout() {
    authToken = null;
    localStorage.removeItem('dbAuthToken');
    showLogin();
}

// Show login screen
function showLogin() {
    loginScreen.style.display = 'flex';
    dbManagement.style.display = 'none';
    loginError.textContent = '';
    document.getElementById('username').value = '';
    document.getElementById('password').value = '';
}

// Show dashboard
function showDashboard() {
    loginScreen.style.display = 'none';
    dbManagement.style.display = 'block';
    isAuthenticated = true;
}

// Show error message
function showError(message) {
    loginError.textContent = message;
}

// Switch tabs
function switchTab(tabName) {
    // Update tab buttons
    tabBtns.forEach(btn => {
        btn.classList.toggle('active', btn.dataset.tab === tabName);
    });
    
    // Update tab content
    tabContents.forEach(content => {
        content.style.display = content.id === `${tabName}-tab` ? 'block' : 'none';
    });
    
    // Load data for the selected tab
    loadTabData(tabName);
}

// Load initial data
function loadInitialData() {
    loadTabData('quizzes');
}

// Load data for specific tab
async function loadTabData(tabName) {
    if (!isAuthenticated) return;
    
    try {
        switch (tabName) {
            case 'quizzes':
                await loadQuizzes();
                break;
            case 'questions':
                await loadQuestions();
                break;
            case 'personality-types':
                await loadPersonalityTypes();
                break;
            case 'advice':
                await loadAdvice();
                break;
            case 'question-weights':
                await loadQuestionWeights();
                break;
            case 'validation-rules':
                await loadValidationRules();
                break;
            case 'business-rules':
                await loadBusinessRules();
                break;
            case 'system-config':
                await loadSystemConfig();
                break;
        }
    } catch (error) {
        console.error(`Error loading ${tabName}:`, error);
    }
}

// Load quizzes
async function loadQuizzes() {
    const response = await fetch('/api/db/quizzes', {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (response.ok) {
        const quizzes = await response.json();
        displayQuizzes(quizzes);
    }
}

// Display quizzes in table
function displayQuizzes(quizzes) {
    const tbody = document.querySelector('#quizzes-table tbody');
    tbody.innerHTML = '';
    
    quizzes.forEach(quiz => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${quiz.id}</td>
            <td>${quiz.title}</td>
            <td>${quiz.description || ''}</td>
            <td>${quiz.result_title || 'Personality Type'}</td>
            <td>${new Date(quiz.created_at).toLocaleDateString()}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editQuiz(${quiz.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteQuiz(${quiz.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Global variables for questions and personality types data
let allQuestions = [];
let allQuizzes = [];
let allPersonalityTypes = [];

// Load questions
async function loadQuestions() {
    const response = await fetch('/api/db/questions', {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (response.ok) {
        allQuestions = await response.json();
        await populateQuizSelector();
        displayQuestions(allQuestions);
    }
}

// Populate quiz selector dropdown
async function populateQuizSelector() {
    if (allQuizzes.length === 0) {
        const response = await fetch('/api/db/quizzes', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        if (response.ok) {
            allQuizzes = await response.json();
        }
    }
    
    const selector = document.getElementById('quiz-selector');
    selector.innerHTML = '<option value="">-- Select a Quiz --</option>';
    
    allQuizzes.forEach(quiz => {
        const option = document.createElement('option');
        option.value = quiz.id;
        option.textContent = `${quiz.id} - ${quiz.title}`;
        selector.appendChild(option);
    });
    
    // Add event listener for quiz selection
    selector.addEventListener('change', function() {
        const selectedQuizId = this.value;
        if (selectedQuizId) {
            const filteredQuestions = allQuestions.filter(q => q.quiz_id == selectedQuizId);
            displayQuestions(filteredQuestions);
        } else {
            displayQuestions(allQuestions);
        }
    });
}

// Display questions in table
function displayQuestions(questions) {
    const tbody = document.querySelector('#questions-table tbody');
    tbody.innerHTML = '';
    
    questions.forEach(question => {
        const row = document.createElement('tr');
        
        // Format answer options
        let optionsHtml = '';
        if (question.options && question.options.length > 0) {
            optionsHtml = question.options.map((option, index) => 
                `<div style="margin-bottom: 5px; padding: 3px; background: rgba(255,255,255,0.1); border-radius: 3px; font-size: 12px;">
                    <strong>${index + 1}:</strong> ${option.option_text}
                </div>`
            ).join('');
        } else {
            optionsHtml = '<em style="color: #ccc;">No options loaded</em>';
        }
        
        row.innerHTML = `
            <td>${question.id}</td>
            <td style="max-width: 300px; word-wrap: break-word;">${question.question_text || question.question}</td>
            <td>${question.question_order || question.order_index || 0}</td>
            <td style="max-width: 400px;">${optionsHtml}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editQuestion(${question.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteQuestion(${question.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Load personality types
async function loadPersonalityTypes() {
    const response = await fetch('/api/db/personality-types', {
        headers: {
            'Authorization': `Bearer ${authToken}`
        }
    });
    
    if (response.ok) {
        allPersonalityTypes = await response.json();
        await populateResultsQuizSelector();
        displayPersonalityTypes(allPersonalityTypes);
    }
}

// Populate results quiz selector
async function populateResultsQuizSelector() {
    if (allQuizzes.length === 0) {
        const response = await fetch('/api/db/quizzes', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        if (response.ok) {
            allQuizzes = await response.json();
        }
    }
    
    const selector = document.getElementById('results-quiz-selector');
    selector.innerHTML = '<option value="">-- Select a Quiz --</option>';
    
    allQuizzes.forEach(quiz => {
        const option = document.createElement('option');
        option.value = quiz.id;
        option.textContent = quiz.title;
        selector.appendChild(option);
    });
    
    // Add event listener for filtering
    selector.addEventListener('change', function() {
        const selectedQuizId = this.value;
        if (selectedQuizId) {
            const filteredTypes = allPersonalityTypes.filter(type => type.quiz_id == selectedQuizId);
            displayPersonalityTypes(filteredTypes);
        } else {
            displayPersonalityTypes(allPersonalityTypes);
        }
    });
}

// Display personality types in table
function displayPersonalityTypes(types) {
    const tbody = document.querySelector('#personality-types-table tbody');
    tbody.innerHTML = '';
    
    types.forEach(type => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${type.id}</td>
            <td>${type.type_name || 'N/A'}</td>
            <td>${type.type_key || 'N/A'}</td>
            <td>${type.description ? type.description.substring(0, 50) + '...' : 'N/A'}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editPersonalityType(${type.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deletePersonalityType(${type.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Execute SQL query
async function executeSQL() {
    const query = document.getElementById('sql-editor').value.trim();
    if (!query) {
        alert('Please enter a SQL query');
        return;
    }
    
    try {
        const response = await fetch('/api/db/execute-sql', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify({ query })
        });
        
        const result = await response.json();
        
        if (response.ok) {
            displaySQLResults(result);
        } else {
            alert('SQL Error: ' + result.message);
        }
    } catch (error) {
        alert('Error executing query: ' + error.message);
    }
}

// Display SQL results
function displaySQLResults(result) {
    const resultsContainer = document.getElementById('sql-results');
    
    if (result.rows && result.rows.length > 0) {
        const table = document.createElement('table');
        const thead = document.createElement('thead');
        const tbody = document.createElement('tbody');
        
        // Create header
        const headerRow = document.createElement('tr');
        Object.keys(result.rows[0]).forEach(key => {
            const th = document.createElement('th');
            th.textContent = key;
            headerRow.appendChild(th);
        });
        thead.appendChild(headerRow);
        
        // Create rows
        result.rows.forEach(row => {
            const tr = document.createElement('tr');
            Object.values(row).forEach(value => {
                const td = document.createElement('td');
                td.textContent = value;
                tr.appendChild(td);
            });
            tbody.appendChild(tr);
        });
        
        table.appendChild(thead);
        table.appendChild(tbody);
        resultsContainer.innerHTML = '';
        resultsContainer.appendChild(table);
    } else {
        resultsContainer.innerHTML = '<p style="color: #fff; text-align: center;">Query executed successfully. No results to display.</p>';
    }
}

// CRUD Operations
async function addQuiz() {
    const title = prompt('Enter quiz title:');
    const description = prompt('Enter quiz description:');
    const resultTitle = prompt('Enter result title (e.g., "Personality Type", "Learning Style"):') || 'Personality Type';
    if (title) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `INSERT INTO quizzes (name, title, description, result_title) VALUES ('${title.replace(/'/g, "''")}_quiz', '${title.replace(/'/g, "''")}', '${description ? description.replace(/'/g, "''") : ''}', '${resultTitle.replace(/'/g, "''")}')`
                })
            });
            
            if (response.ok) {
                alert('Quiz added successfully!');
                loadQuizzes();
            } else {
                const error = await response.json();
                alert('Error adding quiz: ' + error.message);
            }
        } catch (error) {
            alert('Error adding quiz: ' + error.message);
        }
    }
}

async function editQuiz(id) {
    try {
        // First get the current quiz data
        const response = await fetch('/api/db/execute-sql', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify({
                query: `SELECT * FROM quizzes WHERE id = ${id}`
            })
        });
        
        if (response.ok) {
            const result = await response.json();
            const quiz = result.rows[0];
            
            if (quiz) {
                const newTitle = prompt('Enter new quiz title:', quiz.title);
                const newDescription = prompt('Enter new quiz description:', quiz.description || '');
                const newResultTitle = prompt('Enter new result title:', quiz.result_title || 'Personality Type');
                
                if (newTitle !== null) {
                    const updateResponse = await fetch('/api/db/execute-sql', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${authToken}`
                        },
                        body: JSON.stringify({
                            query: `UPDATE quizzes SET title = '${newTitle.replace(/'/g, "''")}', description = '${newDescription ? newDescription.replace(/'/g, "''") : ''}', result_title = '${newResultTitle.replace(/'/g, "''")}' WHERE id = ${id}`
                        })
                    });
                    
                    if (updateResponse.ok) {
                        alert('Quiz updated successfully!');
                        loadQuizzes();
                    } else {
                        const error = await updateResponse.json();
                        alert('Error updating quiz: ' + error.message);
                    }
                }
            }
        }
    } catch (error) {
        alert('Error editing quiz: ' + error.message);
    }
}

async function deleteQuiz(id) {
    if (confirm('Are you sure you want to delete this quiz? This will also delete all associated questions and data.')) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `DELETE FROM quizzes WHERE id = ${id}`
                })
            });
            
            if (response.ok) {
                alert('Quiz deleted successfully!');
                loadQuizzes();
            } else {
                const error = await response.json();
                alert('Error deleting quiz: ' + error.message);
            }
        } catch (error) {
            alert('Error deleting quiz: ' + error.message);
        }
    }
}

async function addQuestion() {
    const quizId = prompt('Enter quiz ID:');
    const questionText = prompt('Enter question text:');
    const questionOrder = prompt('Enter question order (number):');
    
    if (quizId && questionText) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `INSERT INTO questions (quiz_id, question_text, question_order) VALUES (${quizId}, '${questionText.replace(/'/g, "''")}', ${questionOrder || 0})`
                })
            });
            
            if (response.ok) {
                alert('Question added successfully!');
                loadQuestions();
            } else {
                const error = await response.json();
                alert('Error adding question: ' + error.message);
            }
        } catch (error) {
            alert('Error adding question: ' + error.message);
        }
    }
}

async function editQuestion(id) {
    try {
        // Get current question data
        const response = await fetch('/api/db/execute-sql', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify({
                query: `SELECT * FROM questions WHERE id = ${id}`
            })
        });
        
        if (response.ok) {
            const result = await response.json();
            const question = result.rows[0];
            
            if (question) {
                const newText = prompt('Enter new question text:', question.question_text);
                const newOrder = prompt('Enter new question order:', question.question_order);
                
                if (newText !== null) {
                    const updateResponse = await fetch('/api/db/execute-sql', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${authToken}`
                        },
                        body: JSON.stringify({
                            query: `UPDATE questions SET question_text = '${newText.replace(/'/g, "''")}', question_order = ${newOrder || 0} WHERE id = ${id}`
                        })
                    });
                    
                    if (updateResponse.ok) {
                        alert('Question updated successfully!');
                        loadQuestions();
                    } else {
                        const error = await updateResponse.json();
                        alert('Error updating question: ' + error.message);
                    }
                }
            }
        }
    } catch (error) {
        alert('Error editing question: ' + error.message);
    }
}

async function deleteQuestion(id) {
    if (confirm('Are you sure you want to delete this question?')) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `DELETE FROM questions WHERE id = ${id}`
                })
            });
            
            if (response.ok) {
                alert('Question deleted successfully!');
                loadQuestions();
            } else {
                const error = await response.json();
                alert('Error deleting question: ' + error.message);
            }
        } catch (error) {
            alert('Error deleting question: ' + error.message);
        }
    }
}

async function addPersonalityType() {
    const quizId = prompt('Enter quiz ID:');
    const typeName = prompt('Enter personality type name:');
    const typeKey = prompt('Enter personality type key:');
    const description = prompt('Enter description:');
    
    if (quizId && typeName && typeKey) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `INSERT INTO personality_types (quiz_id, type_name, type_key, description) VALUES (${quizId}, '${typeName.replace(/'/g, "''")}', '${typeKey.replace(/'/g, "''")}', '${description ? description.replace(/'/g, "''") : ''}')`
                })
            });
            
            if (response.ok) {
                alert('Personality type added successfully!');
                loadPersonalityTypes();
            } else {
                const error = await response.json();
                alert('Error adding personality type: ' + error.message);
            }
        } catch (error) {
            alert('Error adding personality type: ' + error.message);
        }
    }
}

async function editPersonalityType(id) {
    try {
        // Get current personality type data
        const response = await fetch('/api/db/execute-sql', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${authToken}`
            },
            body: JSON.stringify({
                query: `SELECT * FROM personality_types WHERE id = ${id}`
            })
        });
        
        if (response.ok) {
            const result = await response.json();
            const type = result.rows[0];
            
            if (type) {
                const newName = prompt('Enter new personality type name:', type.type_name);
                const newKey = prompt('Enter new personality type key:', type.type_key);
                const newDescription = prompt('Enter new description:', type.description || '');
                
                if (newName !== null && newKey !== null) {
                    const updateResponse = await fetch('/api/db/execute-sql', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${authToken}`
                        },
                        body: JSON.stringify({
                            query: `UPDATE personality_types SET type_name = '${newName.replace(/'/g, "''")}', type_key = '${newKey.replace(/'/g, "''")}', description = '${newDescription ? newDescription.replace(/'/g, "''") : ''}' WHERE id = ${id}`
                        })
                    });
                    
                    if (updateResponse.ok) {
                        alert('Personality type updated successfully!');
                        loadPersonalityTypes();
                    } else {
                        const error = await updateResponse.json();
                        alert('Error updating personality type: ' + error.message);
                    }
                }
            }
        }
    } catch (error) {
        alert('Error editing personality type: ' + error.message);
    }
}

async function deletePersonalityType(id) {
    if (confirm('Are you sure you want to delete this personality type?')) {
        try {
            const response = await fetch('/api/db/execute-sql', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    query: `DELETE FROM personality_types WHERE id = ${id}`
                })
            });
            
            if (response.ok) {
                alert('Personality type deleted successfully!');
                loadPersonalityTypes();
            } else {
                const error = await response.json();
                alert('Error deleting personality type: ' + error.message);
            }
        } catch (error) {
            alert('Error deleting personality type: ' + error.message);
        }
    }
}

// ===== CONFIGURATION MANAGEMENT FUNCTIONS =====

// Question Weights Management
async function loadQuestionWeights() {
    try {
        await populateWeightsQuizSelector();
        let selectedQuizId = document.getElementById('weights-quiz-selector').value;
        
        // If no quiz is selected, automatically select the first one
        if (!selectedQuizId && allQuizzes.length > 0) {
            selectedQuizId = allQuizzes[0].id;
            document.getElementById('weights-quiz-selector').value = selectedQuizId;
        }
        
        if (selectedQuizId) {
            const response = await fetch(`/api/db/question-weights/${selectedQuizId}`, {
                headers: {
                    'Authorization': `Bearer ${authToken}`
                }
            });
            
            if (response.ok) {
                const weights = await response.json();
                displayQuestionWeights(weights);
            }
        }
    } catch (error) {
        console.error('Error loading question weights:', error);
    }
}

async function populateWeightsQuizSelector() {
    // Load quizzes if not already loaded
    if (allQuizzes.length === 0) {
        const response = await fetch('/api/db/quizzes', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        if (response.ok) {
            allQuizzes = await response.json();
        }
    }
    
    const selector = document.getElementById('weights-quiz-selector');
    selector.innerHTML = '<option value="">Select Quiz...</option>';
    
    allQuizzes.forEach(quiz => {
        const option = document.createElement('option');
        option.value = quiz.id;
        option.textContent = quiz.title || `Quiz ${quiz.id}`;
        selector.appendChild(option);
    });
    
    // Remove existing event listeners to prevent duplicates
    const newSelector = selector.cloneNode(true);
    selector.parentNode.replaceChild(newSelector, selector);
    newSelector.addEventListener('change', loadQuestionWeights);
}

function displayQuestionWeights(weights) {
    const tbody = document.querySelector('#question-weights-table tbody');
    tbody.innerHTML = '';
    
    weights.forEach(weight => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${weight.id}</td>
            <td style="max-width: 300px; word-wrap: break-word;">${weight.question_text || 'N/A'}</td>
            <td>${weight.weight_multiplier}</td>
            <td>${weight.importance_level}</td>
            <td>${weight.is_required ? 'Yes' : 'No'}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editQuestionWeight(${weight.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteQuestionWeight(${weight.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

async function addQuestionWeight() {
    const quizId = document.getElementById('weights-quiz-selector').value;
    if (!quizId) {
        alert('Please select a quiz first');
        return;
    }
    
    const questionId = prompt('Enter Question ID:');
    const weightMultiplier = prompt('Enter Weight Multiplier (e.g., 1.5):', '1.0');
    const importanceLevel = prompt('Enter Importance Level (low/normal/high/critical):', 'normal');
    const isRequired = confirm('Is this question required?');
    
    if (questionId && weightMultiplier) {
        try {
            const response = await fetch('/api/db/question-weights', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    quizId: parseInt(quizId),
                    questionId: parseInt(questionId),
                    weightMultiplier: parseFloat(weightMultiplier),
                    importanceLevel,
                    isRequired
                })
            });
            
            if (response.ok) {
                alert('Question weight added successfully!');
                loadQuestionWeights();
            } else {
                alert('Error adding question weight');
            }
        } catch (error) {
            console.error('Error adding question weight:', error);
            alert('Error adding question weight');
        }
    }
}

// Validation Rules Management
async function loadValidationRules() {
    try {
        await populateValidationQuizSelector();
        let selectedQuizId = document.getElementById('validation-quiz-selector').value;
        
        // If no quiz is selected, automatically select the first one
        if (!selectedQuizId && allQuizzes.length > 0) {
            selectedQuizId = allQuizzes[0].id;
            document.getElementById('validation-quiz-selector').value = selectedQuizId;
        }
        
        if (selectedQuizId) {
            const response = await fetch(`/api/db/validation-rules/${selectedQuizId}`, {
                headers: {
                    'Authorization': `Bearer ${authToken}`
                }
            });
            
            if (response.ok) {
                const rules = await response.json();
                displayValidationRules(rules);
            }
        }
    } catch (error) {
        console.error('Error loading validation rules:', error);
    }
}

async function populateValidationQuizSelector() {
    // Load quizzes if not already loaded
    if (allQuizzes.length === 0) {
        const response = await fetch('/api/db/quizzes', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        if (response.ok) {
            allQuizzes = await response.json();
        }
    }
    
    const selector = document.getElementById('validation-quiz-selector');
    selector.innerHTML = '<option value="">Select Quiz...</option>';
    
    allQuizzes.forEach(quiz => {
        const option = document.createElement('option');
        option.value = quiz.id;
        option.textContent = quiz.title || `Quiz ${quiz.id}`;
        selector.appendChild(option);
    });
    
    // Remove existing event listeners to prevent duplicates
    const newSelector = selector.cloneNode(true);
    selector.parentNode.replaceChild(newSelector, selector);
    newSelector.addEventListener('change', loadValidationRules);
}

function displayValidationRules(rules) {
    const tbody = document.querySelector('#validation-rules-table tbody');
    tbody.innerHTML = '';
    
    rules.forEach(rule => {
        const row = document.createElement('tr');
        const config = typeof rule.rule_config === 'string' ? rule.rule_config : JSON.stringify(rule.rule_config);
        row.innerHTML = `
            <td>${rule.id}</td>
            <td>${rule.rule_name}</td>
            <td>${rule.rule_type}</td>
            <td style="max-width: 200px; word-wrap: break-word; font-size: 12px;">${config}</td>
            <td style="max-width: 200px; word-wrap: break-word;">${rule.error_message || 'N/A'}</td>
            <td>${rule.is_active ? 'Yes' : 'No'}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editValidationRule(${rule.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteValidationRule(${rule.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

async function addValidationRule() {
    const quizId = document.getElementById('validation-quiz-selector').value;
    if (!quizId) {
        alert('Please select a quiz first');
        return;
    }
    
    const ruleName = prompt('Enter Rule Name:');
    const ruleType = prompt('Enter Rule Type (completion_rate/answer_validation/time_limit):');
    const ruleConfig = prompt('Enter Rule Configuration (JSON):');
    const errorMessage = prompt('Enter Error Message:');
    const isActive = confirm('Is this rule active?');
    
    if (ruleName && ruleType && ruleConfig) {
        try {
            const response = await fetch('/api/db/validation-rules', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    quizId: parseInt(quizId),
                    ruleName,
                    ruleType,
                    ruleConfig,
                    errorMessage,
                    isActive
                })
            });
            
            if (response.ok) {
                alert('Validation rule added successfully!');
                loadValidationRules();
            } else {
                alert('Error adding validation rule');
            }
        } catch (error) {
            console.error('Error adding validation rule:', error);
            alert('Error adding validation rule');
        }
    }
}

// Business Rules Management
async function loadBusinessRules() {
    try {
        await populateBusinessQuizSelector();
        let selectedQuizId = document.getElementById('business-quiz-selector').value;
        
        // If no quiz is selected, automatically select the first one
        if (!selectedQuizId && allQuizzes.length > 0) {
            selectedQuizId = allQuizzes[0].id;
            document.getElementById('business-quiz-selector').value = selectedQuizId;
        }
        
        if (selectedQuizId) {
            const response = await fetch(`/api/db/business-rules/${selectedQuizId}`, {
                headers: {
                    'Authorization': `Bearer ${authToken}`
                }
            });
            
            if (response.ok) {
                const rules = await response.json();
                displayBusinessRules(rules);
            }
        }
    } catch (error) {
        console.error('Error loading business rules:', error);
    }
}

async function populateBusinessQuizSelector() {
    // Load quizzes if not already loaded
    if (allQuizzes.length === 0) {
        const response = await fetch('/api/db/quizzes', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        if (response.ok) {
            allQuizzes = await response.json();
        }
    }
    
    const selector = document.getElementById('business-quiz-selector');
    selector.innerHTML = '<option value="">Select Quiz...</option>';
    
    allQuizzes.forEach(quiz => {
        const option = document.createElement('option');
        option.value = quiz.id;
        option.textContent = quiz.title || `Quiz ${quiz.id}`;
        selector.appendChild(option);
    });
    
    // Remove existing event listeners to prevent duplicates
    const newSelector = selector.cloneNode(true);
    selector.parentNode.replaceChild(newSelector, selector);
    newSelector.addEventListener('change', loadBusinessRules);
}

function displayBusinessRules(rules) {
    const tbody = document.querySelector('#business-rules-table tbody');
    tbody.innerHTML = '';
    
    rules.forEach(rule => {
        const row = document.createElement('tr');
        const config = typeof rule.rule_config === 'string' ? rule.rule_config : JSON.stringify(rule.rule_config);
        row.innerHTML = `
            <td>${rule.id}</td>
            <td>${rule.rule_name}</td>
            <td>${rule.rule_category}</td>
            <td style="max-width: 200px; word-wrap: break-word; font-size: 12px;">${config}</td>
            <td>${rule.priority}</td>
            <td>${rule.is_active ? 'Yes' : 'No'}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editBusinessRule(${rule.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteBusinessRule(${rule.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

async function addBusinessRule() {
    const quizId = document.getElementById('business-quiz-selector').value;
    if (!quizId) {
        alert('Please select a quiz first');
        return;
    }
    
    const ruleName = prompt('Enter Rule Name:');
    const ruleCategory = prompt('Enter Rule Category (scoring/completion/result_display):');
    const ruleConfig = prompt('Enter Rule Configuration (JSON):');
    const priority = prompt('Enter Priority (0-10):', '0');
    const isActive = confirm('Is this rule active?');
    
    if (ruleName && ruleCategory && ruleConfig) {
        try {
            const response = await fetch('/api/db/business-rules', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    quizId: parseInt(quizId),
                    ruleName,
                    ruleCategory,
                    ruleConfig,
                    priority: parseInt(priority),
                    isActive
                })
            });
            
            if (response.ok) {
                alert('Business rule added successfully!');
                loadBusinessRules();
            } else {
                alert('Error adding business rule');
            }
        } catch (error) {
            console.error('Error adding business rule:', error);
            alert('Error adding business rule');
        }
    }
}

// System Configuration Management
async function loadSystemConfig() {
    try {
        const filterType = document.getElementById('config-type-filter').value;
        const url = filterType ? `/api/db/system-config/type/${filterType}` : '/api/db/system-config';
        
        const response = await fetch(url, {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        
        if (response.ok) {
            const configs = await response.json();
            displaySystemConfig(configs);
        }
    } catch (error) {
        console.error('Error loading system config:', error);
    }
}

function displaySystemConfig(configs) {
    const tbody = document.querySelector('#system-config-table tbody');
    tbody.innerHTML = '';
    
    configs.forEach(config => {
        const row = document.createElement('tr');
        const value = typeof config.config_value === 'string' ? config.config_value : JSON.stringify(config.config_value);
        row.innerHTML = `
            <td>${config.id}</td>
            <td>${config.config_key}</td>
            <td>${config.config_type}</td>
            <td style="max-width: 200px; word-wrap: break-word; font-size: 12px;">${value}</td>
            <td style="max-width: 200px; word-wrap: break-word;">${config.description || 'N/A'}</td>
            <td>${config.is_active ? 'Yes' : 'No'}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editSystemConfig('${config.config_key}')">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteSystemConfig('${config.config_key}')">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

async function addSystemConfig() {
    const configKey = prompt('Enter Config Key:');
    const configType = prompt('Enter Config Type (pricing/display/calculation/validation):');
    const configValue = prompt('Enter Config Value (JSON):');
    const description = prompt('Enter Description:');
    const isActive = confirm('Is this config active?');
    
    if (configKey && configType && configValue) {
        try {
            const response = await fetch('/api/db/system-config', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    configKey,
                    configType,
                    configValue,
                    description,
                    isActive
                })
            });
            
            if (response.ok) {
                alert('System config added successfully!');
                loadSystemConfig();
            } else {
                alert('Error adding system config');
            }
        } catch (error) {
            console.error('Error adding system config:', error);
            alert('Error adding system config');
        }
    }
}

// Setup filter change listener
document.addEventListener('DOMContentLoaded', function() {
    const configFilter = document.getElementById('config-type-filter');
    if (configFilter) {
        configFilter.addEventListener('change', loadSystemConfig);
    }
});

// Placeholder edit and delete functions for new tables
async function editQuestionWeight(id) {
    alert('Edit functionality will be implemented in the next update');
}

async function deleteQuestionWeight(id) {
    if (confirm('Are you sure you want to delete this question weight?')) {
        // Implementation will be added
        alert('Delete functionality will be implemented in the next update');
    }
}

async function editValidationRule(id) {
    alert('Edit functionality will be implemented in the next update');
}

async function deleteValidationRule(id) {
    if (confirm('Are you sure you want to delete this validation rule?')) {
        // Implementation will be added
        alert('Delete functionality will be implemented in the next update');
    }
}

async function editBusinessRule(id) {
    alert('Edit functionality will be implemented in the next update');
}

async function deleteBusinessRule(id) {
    if (confirm('Are you sure you want to delete this business rule?')) {
        // Implementation will be added
        alert('Delete functionality will be implemented in the next update');
    }
}

async function editSystemConfig(configKey) {
    alert('Edit functionality will be implemented in the next update');
}

async function deleteSystemConfig(configKey) {
    if (confirm('Are you sure you want to delete this system config?')) {
        // Implementation will be added
        alert('Delete functionality will be implemented in the next update');
    }
}

// Advice Management Functions
let allAdvice = [];

async function loadAdvice() {
    try {
        // Load personality types first if not already loaded
        if (allPersonalityTypes.length === 0) {
            await loadPersonalityTypes();
        }
        
        const response = await fetch('/api/advice', {
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });
        
        if (response.ok) {
            allAdvice = await response.json();
            displayAdvice(allAdvice);
            await populateAdvicePersonalitySelector();
        } else {
            console.error('Failed to load advice');
        }
    } catch (error) {
        console.error('Error loading advice:', error);
    }
}

async function populateAdvicePersonalitySelector() {
    const selector = document.getElementById('advice-personality-selector');
    selector.innerHTML = '<option value="">Select Personality Type...</option>';
    
    // Load personality types if not already loaded
    if (allPersonalityTypes.length === 0) {
        await loadPersonalityTypes();
    }
    
    allPersonalityTypes.forEach(type => {
        const option = document.createElement('option');
        option.value = type.id;
        option.textContent = `${type.type_name} - ${type.title}`;
        selector.appendChild(option);
    });
}

function displayAdvice(advice) {
    const tbody = document.querySelector('#advice-table tbody');
    tbody.innerHTML = '';
    
    advice.forEach(item => {
        const row = document.createElement('tr');
        
        // Find personality type name
        const personalityType = allPersonalityTypes.find(pt => pt.id === item.personality_type_id);
        const typeName = personalityType ? personalityType.type_name : 'Unknown';
        
        row.innerHTML = `
            <td>${item.id}</td>
            <td>${typeName}</td>
            <td>${item.advice_type}</td>
            <td>${item.advice_text.substring(0, 100)}${item.advice_text.length > 100 ? '...' : ''}</td>
            <td>${item.advice_order}</td>
            <td>
                <button class="btn action-btn edit-btn" onclick="editAdvice(${item.id})">Edit</button>
                <button class="btn action-btn delete-btn" onclick="deleteAdvice(${item.id})">Delete</button>
            </td>
        `;
        
        tbody.appendChild(row);
    });
}

async function addAdvice() {
    const personalityTypeId = prompt('Enter Personality Type ID:');
    const adviceType = prompt('Enter Advice Type (personality/relationship):');
    const adviceText = prompt('Enter Advice Text:');
    const adviceOrder = prompt('Enter Advice Order (number):') || '0';
    
    if (personalityTypeId && adviceType && adviceText) {
        try {
            const response = await fetch('/api/advice', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    personality_type_id: parseInt(personalityTypeId),
                    advice_type: adviceType,
                    advice_text: adviceText,
                    advice_order: parseInt(adviceOrder)
                })
            });
            
            if (response.ok) {
                await loadAdvice();
                alert('Advice added successfully!');
            } else {
                alert('Failed to add advice');
            }
        } catch (error) {
            console.error('Error adding advice:', error);
            alert('Error adding advice');
        }
    }
}

async function editAdvice(id) {
    const advice = allAdvice.find(a => a.id === id);
    if (!advice) return;
    
    const personalityTypeId = prompt('Enter Personality Type ID:', advice.personality_type_id);
    const adviceType = prompt('Enter Advice Type (personality/relationship):', advice.advice_type);
    const adviceText = prompt('Enter Advice Text:', advice.advice_text);
    const adviceOrder = prompt('Enter Advice Order (number):', advice.advice_order);
    
    if (personalityTypeId && adviceType && adviceText) {
        try {
            const response = await fetch(`/api/advice/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${authToken}`
                },
                body: JSON.stringify({
                    personality_type_id: parseInt(personalityTypeId),
                    advice_type: adviceType,
                    advice_text: adviceText,
                    advice_order: parseInt(adviceOrder)
                })
            });
            
            if (response.ok) {
                await loadAdvice();
                alert('Advice updated successfully!');
            } else {
                alert('Failed to update advice');
            }
        } catch (error) {
            console.error('Error updating advice:', error);
            alert('Error updating advice');
        }
    }
}

async function deleteAdvice(id) {
    if (confirm('Are you sure you want to delete this advice?')) {
        try {
            const response = await fetch(`/api/advice/${id}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${authToken}`
                }
            });
            
            if (response.ok) {
                await loadAdvice();
                alert('Advice deleted successfully!');
            } else {
                alert('Failed to delete advice');
            }
        } catch (error) {
            console.error('Error deleting advice:', error);
            alert('Error deleting advice');
        }
    }
}