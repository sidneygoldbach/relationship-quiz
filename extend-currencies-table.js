const db = require('./database');

/**
 * Script para estender a tabela currencies com informações de locale
 * Adiciona colunas name e flag, e popula com dados que estão hardcoded
 */

async function extendCurrenciesTable() {
    console.log('🔄 Estendendo tabela currencies para incluir informações de locale...');
    
    try {
        // 1. Adicionar colunas name e flag à tabela currencies
        console.log('📊 Adicionando colunas name e flag...');
        
        if (db.dbType === 'postgresql') {
            // PostgreSQL
            await db.pool.query(`
                ALTER TABLE currencies 
                ADD COLUMN IF NOT EXISTS name VARCHAR(100),
                ADD COLUMN IF NOT EXISTS flag VARCHAR(10)
            `);
        } else {
            // SQLite
            await new Promise((resolve, reject) => {
                db.pool.run('ALTER TABLE currencies ADD COLUMN name VARCHAR(100)', (err) => {
                    if (err && !err.message.includes('duplicate column name')) {
                        console.log('⚠️ Erro ao adicionar coluna name (pode já existir):', err.message);
                    }
                });
                
                db.pool.run('ALTER TABLE currencies ADD COLUMN flag VARCHAR(10)', (err) => {
                    if (err && !err.message.includes('duplicate column name')) {
                        console.log('⚠️ Erro ao adicionar coluna flag (pode já existir):', err.message);
                    }
                    resolve();
                });
            });
        }
        
        console.log('✅ Colunas adicionadas com sucesso!');
        
        // 2. Popular com dados dos mapeamentos hardcoded
        console.log('📝 Populando com dados de locale...');
        
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
                        amount = EXCLUDED.amount
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
            
            console.log(`  ✓ ${locale.country}: ${locale.name} ${locale.flag}`);
        }
        
        // 3. Verificar dados inseridos
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
        
        console.log('\n✅ Tabela currencies estendida com sucesso!');
        console.log('🎯 Agora a tabela currencies pode servir como repositório completo de informações de locale.');
        
    } catch (error) {
        console.error('❌ Erro ao estender tabela currencies:', error);
        throw error;
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    extendCurrenciesTable()
        .then(() => {
            console.log('🎉 Script concluído com sucesso!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('💥 Script falhou:', error);
            process.exit(1);
        });
}

module.exports = { extendCurrenciesTable };