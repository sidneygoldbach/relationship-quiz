const fs = require('fs');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

// SQLite database connection
const dbPath = path.join(__dirname, 'quiz_app.db');
const db = new sqlite3.Database(dbPath);

async function debugPaymentPortuguese() {
    console.log('=== DEBUGGING PAYMENT SCREEN IN PORTUGUESE ===\n');
    
    try {
        // 1. Check if pt_BR.json exists and has payment translations
        console.log('1. Checking pt_BR.json file...');
        const ptBRPath = path.join(__dirname, 'locales', 'pt_BR.json');
        
        if (fs.existsSync(ptBRPath)) {
            const ptBRContent = JSON.parse(fs.readFileSync(ptBRPath, 'utf8'));
            console.log('✓ pt_BR.json exists');
            
            if (ptBRContent.payment) {
                console.log('✓ Payment section exists in pt_BR.json');
                console.log('Payment translations:');
                Object.keys(ptBRContent.payment).forEach(key => {
                    console.log(`  ${key}: "${ptBRContent.payment[key]}"`);
                });
            } else {
                console.log('✗ Payment section missing in pt_BR.json');
            }
        } else {
            console.log('✗ pt_BR.json file not found');
        }
        
        console.log('\n2. Checking database for Portuguese translations...');
        
        // Check if translations table exists and has Portuguese entries
        const translationsQuery = `
            SELECT key, value 
            FROM translations 
            WHERE locale = 'pt_BR' 
            AND key LIKE 'payment.%'
            ORDER BY key;
        `;
        
        const translationsResult = await new Promise((resolve, reject) => {
            db.all(translationsQuery, (err, rows) => {
                if (err) {
                    console.log('Translations table may not exist:', err.message);
                    resolve([]);
                } else {
                    resolve(rows);
                }
            });
        });
        
        if (translationsResult.length > 0) {
            console.log('✓ Found Portuguese payment translations in database:');
            translationsResult.forEach(row => {
                console.log(`  ${row.key}: "${row.value}"`);
            });
        } else {
            console.log('✗ No Portuguese payment translations found in database');
        }
        
        console.log('\n3. Checking currency configuration...');
        
        // Check currency settings for pt_BR
        const currencyQuery = `
            SELECT * FROM currency_settings 
            WHERE locale = 'pt_BR';
        `;
        
        const currencyResult = await new Promise((resolve, reject) => {
            db.all(currencyQuery, (err, rows) => {
                if (err) {
                    console.log('Currency settings table may not exist:', err.message);
                    resolve([]);
                } else {
                    resolve(rows);
                }
            });
        });
        
        if (currencyResult.length > 0) {
            console.log('✓ Found Portuguese currency settings:');
            currencyResult.forEach(row => {
                console.log(`  Locale: ${row.locale}`);
                console.log(`  Currency: ${row.currency}`);
                console.log(`  Symbol: ${row.symbol}`);
                console.log(`  Amount: ${row.amount}`);
            });
        } else {
            console.log('✗ No Portuguese currency settings found');
        }
        
        console.log('\n4. Checking HTML payment button configuration...');
        
        // Check the HTML file for payment button configuration
        const htmlPath = path.join(__dirname, 'index.html');
        if (fs.existsSync(htmlPath)) {
            const htmlContent = fs.readFileSync(htmlPath, 'utf8');
            
            // Look for payment button
            if (htmlContent.includes('submit-payment')) {
                console.log('✓ Payment button found in HTML');
                
                // Check if it has data-i18n attribute
                if (htmlContent.includes('data-i18n="payment.')) {
                    console.log('✓ Payment button has i18n attribute');
                } else {
                    console.log('✗ Payment button missing i18n attribute');
                    console.log('  The button text is set via JavaScript, not HTML attributes');
                }
            }
        }
        
        console.log('\n5. Checking i18n configuration...');
        
        // Check i18n.js file
        const i18nPath = path.join(__dirname, 'i18n.js');
        if (fs.existsSync(i18nPath)) {
            console.log('✓ i18n.js file exists');
        } else {
            console.log('✗ i18n.js file not found');
        }
        
        console.log('\n6. Recommendations:');
        
        // Provide recommendations based on findings
        if (translationsResult.length === 0) {
            console.log('• The payment translations exist in pt_BR.json but not in database');
            console.log('• This suggests the system is using file-based translations, not database');
        }
        
        if (currencyResult.length === 0) {
            console.log('• No Portuguese currency settings found');
            console.log('• The system may be using default USD pricing for all locales');
        }
        
        console.log('• The issue might be:');
        console.log('  1. Payment button text not being translated properly');
        console.log('  2. Currency not being localized for Portuguese');
        console.log('  3. JavaScript not applying translations correctly');
        console.log('  4. Missing data-i18n attributes on payment elements');
        
    } catch (error) {
        console.error('Error during debugging:', error);
    } finally {
        db.close();
    }
}

// Run the debug
debugPaymentPortuguese();