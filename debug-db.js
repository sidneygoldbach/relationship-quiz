const { getCompleteQuizData } = require('./database');

async function testDatabase() {
    try {
        console.log('Testing database connection...');
        const quizData = await getCompleteQuizData(1);
        console.log('Quiz data:', JSON.stringify(quizData, null, 2));
    } catch (error) {
        console.error('Error:', error);
    }
}

testDatabase();