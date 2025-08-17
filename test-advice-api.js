const jwt = require('jsonwebtoken');
const http = require('http');

async function testAdviceAPI() {
    try {
        // Generate JWT token
        const token = jwt.sign({username: 'admin'}, 'your-secret-key-change-in-production');
        console.log('Generated token:', token);
        
        // Make request to advice API using http module
        const options = {
            hostname: 'localhost',
            port: 3000,
            path: '/api/advice',
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        };
        
        const req = http.request(options, (res) => {
            console.log('Response status:', res.statusCode);
            console.log('Response headers:', res.headers);
            
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                try {
                    if (res.statusCode === 200) {
                        const jsonData = JSON.parse(data);
                        console.log('Advice data:', JSON.stringify(jsonData, null, 2));
                        console.log('Number of advice items:', jsonData.length);
                    } else {
                        console.log('Error response:', data);
                    }
                } catch (parseError) {
                    console.log('Raw response:', data);
                    console.error('Parse error:', parseError);
                }
            });
        });
        
        req.on('error', (error) => {
            console.error('Request error:', error);
        });
        
        req.setTimeout(5000, () => {
            console.log('Request timeout');
            req.destroy();
        });
        
        req.end();
    } catch (error) {
        console.error('Error testing advice API:', error);
    }
}

testAdviceAPI();

// Keep the process alive for a few seconds to see the response
setTimeout(() => {
    console.log('Test completed');
    process.exit(0);
}, 6000);