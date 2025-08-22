const db = require('./database');

async function addCountryColumnToCurrencies() {
    try {
        console.log('🔄 Adding country column to currencies table...');
        
        if (db.dbType === 'postgresql') {
            // Add country column if it doesn't exist
            await db.pool.query(`
                ALTER TABLE currencies 
                ADD COLUMN IF NOT EXISTS country VARCHAR(5) DEFAULT 'en_US'
            `);
            
            // Update existing records with country codes
            await db.pool.query(`
                UPDATE currencies 
                SET country = CASE 
                    WHEN currency = 'USD' THEN 'en_US'
                    WHEN currency = 'BRL' THEN 'pt_BR'
                    WHEN currency = 'EUR' THEN 'es_ES'
                    ELSE 'en_US'
                END
                WHERE country IS NULL OR country = 'en_US'
            `);
            
            console.log('✅ Country column added and populated successfully (PostgreSQL)');
        } else {
            // SQLite version
            await new Promise((resolve, reject) => {
                db.pool.run(`
                    ALTER TABLE currencies 
                    ADD COLUMN country VARCHAR(5) DEFAULT 'en_US'
                `, (err) => {
                    if (err && !err.message.includes('duplicate column name')) {
                        reject(err);
                    } else {
                        resolve();
                    }
                });
            });
            
            await new Promise((resolve, reject) => {
                db.pool.run(`
                    UPDATE currencies 
                    SET country = CASE 
                        WHEN currency = 'USD' THEN 'en_US'
                        WHEN currency = 'BRL' THEN 'pt_BR'
                        WHEN currency = 'EUR' THEN 'es_ES'
                        ELSE 'en_US'
                    END
                    WHERE country IS NULL OR country = 'en_US'
                `, (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });
            
            console.log('✅ Country column added and populated successfully (SQLite)');
        }
        
        // Verify the changes
        const currencies = db.dbType === 'postgresql' 
            ? (await db.pool.query('SELECT * FROM currencies')).rows
            : await new Promise((resolve, reject) => {
                db.pool.all('SELECT * FROM currencies', (err, rows) => {
                    if (err) reject(err);
                    else resolve(rows);
                });
            });
            
        console.log('📊 Current currencies with country codes:');
        currencies.forEach(currency => {
            console.log(`  - ${currency.currency}: ${currency.country}`);
        });
        
    } catch (error) {
        console.error('❌ Error adding country column:', error);
        process.exit(1);
    }
}

// Run the migration
addCountryColumnToCurrencies().then(() => {
    console.log('🎉 Migration completed successfully!');
    process.exit(0);
}).catch(error => {
    console.error('💥 Migration failed:', error);
    process.exit(1);
});