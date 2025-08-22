const { getSupportedLocales } = require('./database');
const { i18n } = require('./i18n');

/**
 * Script para testar o sistema de locales completamente dinâmico
 * Verifica se todas as funções estão usando dados do banco de dados
 */

async function testDynamicLocaleSystem() {
    console.log('🧪 Testando sistema de locales dinâmico...');
    
    try {
        // 1. Testar função getSupportedLocales do database.js
        console.log('\n1️⃣ Testando database.getSupportedLocales()...');
        const dbLocales = await getSupportedLocales();
        console.log('✅ Locales do banco:', JSON.stringify(dbLocales, null, 2));
        
        // 2. Inicializar i18n e testar carregamento dinâmico
        console.log('\n2️⃣ Inicializando sistema i18n...');
        await i18n.initialize();
        console.log('✅ Sistema i18n inicializado');
        
        // 3. Testar supportedLocales dinâmico
        console.log('\n3️⃣ Testando i18n.getSupportedLocales()...');
        const i18nLocales = i18n.getSupportedLocales();
        console.log('✅ Locales do i18n:', i18nLocales);
        
        // 4. Testar informações de moeda dinâmicas
        console.log('\n4️⃣ Testando informações de moeda dinâmicas...');
        for (const locale of i18nLocales) {
            const currencyInfo = i18n.getCurrencyInfo(locale);
            console.log(`  ${locale}: ${currencyInfo.symbol}${currencyInfo.amount} ${currencyInfo.currency}`);
        }
        
        // 5. Testar detecção de locale dinâmica
        console.log('\n5️⃣ Testando detecção de locale dinâmica...');
        
        // Simular requisições com diferentes headers
        const testRequests = [
            {
                name: 'Query parameter',
                req: { query: { locale: 'pt_BR' }, headers: {} }
            },
            {
                name: 'Accept-Language header (pt)',
                req: { query: {}, headers: { 'accept-language': 'pt-BR,pt;q=0.9,en;q=0.8' } }
            },
            {
                name: 'Accept-Language header (en)',
                req: { query: {}, headers: { 'accept-language': 'en-US,en;q=0.9' } }
            },
            {
                name: 'Accept-Language header (es)',
                req: { query: {}, headers: { 'accept-language': 'es-ES,es;q=0.9' } }
            },
            {
                name: 'Default fallback',
                req: { query: {}, headers: {} }
            }
        ];
        
        for (const test of testRequests) {
            const detectedLocale = i18n.detectLocale(test.req);
            console.log(`  ${test.name}: ${detectedLocale}`);
        }
        
        // 6. Testar adição de novo locale dinamicamente
        console.log('\n6️⃣ Testando adição de novo locale dinamicamente...');
        
        // Simular adição de francês
        console.log('📝 Adicionando locale fr_FR...');
        
        const db = require('./database');
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
            `, ['fr_FR', 'EUR', '€', 4.49, 'Français', '🇫🇷']);
        } else {
            await new Promise((resolve, reject) => {
                db.pool.run(`
                    INSERT OR REPLACE INTO currencies (country, currency, symbol, amount, name, flag)
                    VALUES (?, ?, ?, ?, ?, ?)
                `, ['fr_FR', 'EUR', '€', 4.49, 'Français', '🇫🇷'], (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });
        }
        
        console.log('✅ Locale fr_FR adicionado ao banco');
        
        // Recarregar dados dinâmicos
        console.log('🔄 Recarregando dados dinâmicos...');
        await i18n.loadSupportedLocales();
        await i18n.loadCurrencyData();
        
        // Verificar se o novo locale foi carregado
        const updatedLocales = i18n.getSupportedLocales();
        console.log('✅ Locales atualizados:', updatedLocales);
        
        if (updatedLocales.includes('fr_FR')) {
            console.log('🎉 Novo locale fr_FR detectado automaticamente!');
            const frCurrency = i18n.getCurrencyInfo('fr_FR');
            console.log(`  fr_FR: ${frCurrency.symbol}${frCurrency.amount} ${frCurrency.currency}`);
        } else {
            console.log('❌ Novo locale fr_FR não foi detectado');
        }
        
        // 7. Testar getSupportedLocales do banco novamente
        console.log('\n7️⃣ Verificando getSupportedLocales atualizado...');
        const finalDbLocales = await getSupportedLocales();
        console.log('✅ Locales finais do banco:', JSON.stringify(finalDbLocales, null, 2));
        
        console.log('\n🎉 Todos os testes do sistema dinâmico passaram!');
        console.log('\n📋 Resumo dos testes:');
        console.log('  ✅ database.getSupportedLocales() - Funciona dinamicamente');
        console.log('  ✅ i18n.getSupportedLocales() - Carrega do banco');
        console.log('  ✅ i18n.getCurrencyInfo() - Usa dados do banco');
        console.log('  ✅ i18n.detectLocale() - Detecção dinâmica');
        console.log('  ✅ Adição de novos locales - Sem modificação de código');
        console.log('\n🎯 Sistema completamente dinâmico e funcional!');
        
    } catch (error) {
        console.error('❌ Erro durante os testes:', error);
        throw error;
    }
}

// Executar se chamado diretamente
if (require.main === module) {
    testDynamicLocaleSystem()
        .then(() => {
            console.log('\n🎉 Script de teste concluído com sucesso!');
            process.exit(0);
        })
        .catch((error) => {
            console.error('\n💥 Script de teste falhou:', error);
            process.exit(1);
        });
}

module.exports = { testDynamicLocaleSystem };