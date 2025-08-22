const express = require('express');
const path = require('path');
const { i18nMiddleware } = require('./i18n');
const { getSupportedLocales } = require('./database');

/**
 * Script para testar o sistema frontend de locales dinâmico
 * Verifica se o middleware e as rotas estão funcionando corretamente
 */

async function testFrontendLocaleSystem() {
    console.log('🌐 Testando sistema frontend de locales dinâmico...');
    
    const app = express();
    
    // Configurar middleware
    app.use(i18nMiddleware);
    app.use(express.static('public'));
    
    // Rota de teste para API de locales
    app.get('/api/locales', async (req, res) => {
        try {
            const locales = await getSupportedLocales();
            res.json(locales);
        } catch (error) {
            console.error('Erro ao buscar locales:', error);
            res.status(500).json({ error: 'Erro interno do servidor' });
        }
    });
    
    // Rota de teste para detecção de locale
    app.get('/test/locale-detection', (req, res) => {
        res.json({
            detectedLocale: req.locale,
            supportedLocales: req.i18n.getSupportedLocales(),
            currencyInfo: req.i18n.getCurrencyInfo(req.locale)
        });
    });
    
    // Rota de teste para tradução
    app.get('/test/translation/:key', (req, res) => {
        const key = req.params.key;
        const translation = req.i18n.t(key);
        res.json({
            locale: req.locale,
            key: key,
            translation: translation
        });
    });
    
    // Página de teste HTML
    app.get('/test', (req, res) => {
        res.send(`
<!DOCTYPE html>
<html lang="${req.locale.split('_')[0]}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teste Sistema Dinâmico de Locales</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .test-section { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 8px; }
        .success { color: green; }
        .error { color: red; }
        .info { color: blue; }
        button { padding: 10px 20px; margin: 5px; cursor: pointer; }
        #results { margin-top: 20px; }
        .result-item { margin: 10px 0; padding: 10px; background: #f5f5f5; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>🧪 Teste Sistema Dinâmico de Locales</h1>
    
    <div class="test-section">
        <h2>Informações Atuais</h2>
        <p><strong>Locale Detectado:</strong> <span class="info">${req.locale}</span></p>
        <p><strong>Locales Suportados:</strong> <span class="info">${req.i18n.getSupportedLocales().join(', ')}</span></p>
        <p><strong>Informações de Moeda:</strong> <span class="info">${JSON.stringify(req.i18n.getCurrencyInfo(req.locale))}</span></p>
    </div>
    
    <div class="test-section">
        <h2>Testes Automáticos</h2>
        <button onclick="testApiLocales()">Testar API /api/locales</button>
        <button onclick="testLocaleDetection()">Testar Detecção de Locale</button>
        <button onclick="testTranslation()">Testar Tradução</button>
        <button onclick="testLanguageSwitcher()">Testar Seletor de Idioma</button>
        <button onclick="runAllTests()">Executar Todos os Testes</button>
        
        <div id="results"></div>
    </div>
    
    <div class="test-section">
        <h2>Seletor de Idioma Dinâmico</h2>
        <div id="language-switcher">Carregando...</div>
    </div>
    
    <script>
        const results = document.getElementById('results');
        
        function addResult(test, success, message) {
            const div = document.createElement('div');
            div.className = 'result-item';
            div.innerHTML = \`<strong>\${test}:</strong> <span class="\${success ? 'success' : 'error'}">\${success ? '✅' : '❌'} \${message}</span>\`;
            results.appendChild(div);
        }
        
        async function testApiLocales() {
            try {
                const response = await fetch('/api/locales');
                const locales = await response.json();
                
                if (Array.isArray(locales) && locales.length > 0) {
                    addResult('API Locales', true, \`\${locales.length} locales carregados: \${locales.map(l => l.code).join(', ')}\`);
                } else {
                    addResult('API Locales', false, 'Nenhum locale retornado');
                }
            } catch (error) {
                addResult('API Locales', false, \`Erro: \${error.message}\`);
            }
        }
        
        async function testLocaleDetection() {
            try {
                const response = await fetch('/test/locale-detection');
                const data = await response.json();
                
                if (data.detectedLocale && data.supportedLocales && data.currencyInfo) {
                    addResult('Detecção de Locale', true, \`Locale: \${data.detectedLocale}, Moeda: \${data.currencyInfo.symbol}\${data.currencyInfo.amount}\`);
                } else {
                    addResult('Detecção de Locale', false, 'Dados incompletos retornados');
                }
            } catch (error) {
                addResult('Detecção de Locale', false, \`Erro: \${error.message}\`);
            }
        }
        
        async function testTranslation() {
            try {
                const response = await fetch('/test/translation/welcome');
                const data = await response.json();
                
                if (data.translation && data.locale) {
                    addResult('Tradução', true, \`Chave 'welcome' em \${data.locale}: \${data.translation}\`);
                } else {
                    addResult('Tradução', false, 'Tradução não encontrada');
                }
            } catch (error) {
                addResult('Tradução', false, \`Erro: \${error.message}\`);
            }
        }
        
        async function testLanguageSwitcher() {
            try {
                // Simular criação do seletor de idioma
                const response = await fetch('/api/locales');
                const locales = await response.json();
                
                const switcher = document.getElementById('language-switcher');
                switcher.innerHTML = '';
                
                const select = document.createElement('select');
                select.onchange = (e) => {
                    window.location.href = \`?locale=\${e.target.value}\`;
                };
                
                locales.forEach(locale => {
                    const option = document.createElement('option');
                    option.value = locale.code;
                    option.textContent = \`\${locale.flag} \${locale.name}\`;
                    option.selected = locale.code === '${req.locale}';
                    select.appendChild(option);
                });
                
                switcher.appendChild(select);
                addResult('Seletor de Idioma', true, \`\${locales.length} opções de idioma carregadas dinamicamente\`);
                
            } catch (error) {
                addResult('Seletor de Idioma', false, \`Erro: \${error.message}\`);
            }
        }
        
        async function runAllTests() {
            results.innerHTML = '';
            await testApiLocales();
            await testLocaleDetection();
            await testTranslation();
            await testLanguageSwitcher();
        }
        
        // Executar teste do seletor de idioma ao carregar
        window.onload = () => {
            testLanguageSwitcher();
        };
    </script>
</body>
</html>
        `);
    });
    
    const PORT = 3002;
    const server = app.listen(PORT, () => {
        console.log(`\n🌐 Servidor de teste frontend rodando em http://localhost:${PORT}`);
        console.log(`📋 Acesse http://localhost:${PORT}/test para testar a interface`);
        console.log(`🔗 API de locales: http://localhost:${PORT}/api/locales`);
        console.log(`\n⏹️  Pressione Ctrl+C para parar o servidor`);
    });
    
    // Graceful shutdown
    process.on('SIGINT', () => {
        console.log('\n🛑 Parando servidor de teste...');
        server.close(() => {
            console.log('✅ Servidor parado');
            process.exit(0);
        });
    });
}

// Executar se chamado diretamente
if (require.main === module) {
    testFrontendLocaleSystem().catch(console.error);
}

module.exports = { testFrontendLocaleSystem };