const db = require('./database');

/**
 * Script para criar a tabela currencies com estrutura completa
 * Inclui colunas para locale, moeda, símbolo, valor, nome e bandeira
 */

async function createCurrenciesTable() {
    console.log('🔄 Criando tabela currencies...');
    
    try {
        if (db.dbType === 'postgresql') {
            // PostgreSQL
            await db.pool.query(`
                CREATE TABLE IF NOT EXISTS currencies (
                    id SERIAL PRIMARY KEY,
                    country VARCHAR(5) NOT NULL UNIQUE,
                    currency VARCHAR(3) NOT NULL,
                    symbol VARCHAR(10) NOT NULL,
                    amount DECIMAL(10,2) NOT NULL,
                    name VARCHAR(100),
                    flag VARCHAR(10),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            `);
        } else {
            // SQLite
            await new Promise((resolve, reject) => {
                db.pool.run(`
                    CREATE TABLE IF NOT EXISTS currencies (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        country VARCHAR(5) NOT NULL UNIQUE,
                        currency VARCHAR(3) NOT NULL,
                        symbol VARCHAR(10) NOT NULL,
                        amount DECIMAL(10,2) NOT NULL,
                        name VARCHAR(100),
                        flag VARCHAR(10),
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
                `, (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });
        }
        
        console.log('✅ Tabela currencies criada com sucesso!');
        
        // Popular com dados iniciais
        console.log('📝 Populando com dados iniciais...');
        
        const localeData = [
            {
                country: 'en_US',
                name: 'English',
                flag: '🇺🇸',
                currency: 'USD',
                symbol: '$',
                amount: 4.99
            },
            {
                country: 'pt_BR',
                name: 'Português (Brasil)',
                flag: '🇧🇷',
                currency: 'BRL',
                symbol: 'R$',
                amount: 24.99
            },
            {
                country: 'es_ES',
                name: 'Español',
                flag: '🇪🇸',
                currency: 'EUR',
                symbol: '€',
                amount: 4.49
            }
        ];
        
        for (const locale of localeData) {
            if (db.dbType === 'postgresql') {
                await db.pool.query(`
                    INSERT INTO currencies (country, currency, symbol, amount, name, flag)
                    VALUES ($1, $2, $3, $4, $5, $6)
                    ON CONFLICT (country) 
                    DO UPDATE SET 
                        name = EXCLUDED.name,
                        flag = EXCLUDED.flag,
                        currency = EXCLUDED.currency,
                        symbol = EXCLUDED.symbol,
                        amount = EXCLUDED.amount,
                        updated_at = CURRENT_TIMESTAMP
                `, [locale.country, locale.currency, locale.symbol, locale.amount, locale.name, locale.flag]);
            } else {
                await new Promise((resolve, reject) => {
                    db.pool.run(`
                        INSERT OR REPLACE INTO currencies (country, currency, symbol, amount, name, flag)
                        VALUES (?, ?, ?, ?, ?, ?)
                    `, [locale.country, locale.currency, locale.symbol, locale.amount, locale.name, locale.flag], (err) => {
                        if (err) reject(err);
                        else resolve();
                    });
                });
            }
            
            console.log(`  ✓ ${locale.country}: ${locale.name} ${locale.flag} - ${locale.symbol}${locale.amount} ${locale.currency}`);
        }
        
        // Verificar dados inseridos
        console.log('\n🔍 Verificando dados inseridos...');
        
        if (db.dbType === 'postgresql') {
            const result = await db.pool.query('SELECT country, name, flag, currency, symbol, amount FROM currencies ORDER BY country');
            console.log('\n📊 Dados na tabela currencies:');
            result.rows.forEach(row => {
                console.log(`  ${row.country}: ${row.name} ${row.flag} - ${row.symbol}${row.amount} ${row.currency}`);
            });
        } else {
            await new Promise((resolve, reject) => {
                db.pool.all('SELECT country, name, flag, currency, symbol, amount FROM currencies ORDER BY country', (err, rows) => {
                    if (err) reject(err);
                    else {
                        console.log('\n📊 Dados na tabela currencies:');
                        rows.forEach(row => {
                            console.log(`  ${row.country}: ${row.name} ${row.flag} - ${row.symbol}${row.amount} ${row.currency}`);
                        });
                        resolve();
                    }
                });
            });
        }
        
        console.log('\n✅ Tabela currencies criada e populada com sucesso!');
        console.log('🎯 A tabela currencies agora serve como repositório completo de informações de locale.');
        
    } catch (error) {
        console.error('❌ Erro ao criar tabela currencies:', error);
        throw error;
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    createCurrenciesTable()
        .then(() => {
            console.log('🎉 Script concluído com sucesso!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('💥 Script falhou:', error);
            process.exit(1);
        });
}

module.exports = { createCurrenciesTable };