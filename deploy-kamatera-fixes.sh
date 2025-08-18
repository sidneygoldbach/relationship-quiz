#!/bin/bash

# Script para aplicar correções no servidor Kamatera
# Execute este script no servidor Kamatera após fazer o git pull

echo "🚀 Iniciando deploy das correções no Kamatera..."

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Erro: Execute este script no diretório do projeto!"
    exit 1
fi

# Fazer backup do banco antes das alterações
echo "💾 Fazendo backup do banco de dados..."
sudo -u postgres pg_dump relationshipquiz > backup_before_fixes_$(date +%Y%m%d_%H%M%S).sql

# Parar o serviço temporariamente
echo "⏸️ Parando o serviço..."
sudo systemctl stop relationship-quiz

# Fazer git pull para pegar as últimas alterações
echo "📥 Atualizando código do GitHub..."
git pull origin main

# Instalar dependências se necessário
echo "📦 Verificando dependências..."
npm install

# Executar script de correção da pergunta 24
echo "🔧 Corrigindo pergunta 24 sem opções..."
node fix-kamatera-question24.js

# Verificar se as correções foram aplicadas
echo "🔍 Verificando correções..."
node -e "
const { Pool } = require('pg');
const pool = new Pool({
  user: 'relationshipquiz',
  host: 'localhost', 
  database: 'relationshipquiz',
  password: 'your_secure_password_here',
  port: 5432
});

async function verify() {
  const client = await pool.connect();
  try {
    const result = await client.query('SELECT COUNT(*) as count FROM answer_options WHERE question_id = 24');
    console.log('Pergunta 24 tem', result.rows[0].count, 'opções');
    
    const locales = await client.query('SELECT COUNT(*) as count FROM translations WHERE key = \'finish_quiz\'');
    console.log('Chave finish_quiz encontrada', locales.rows[0].count, 'vezes');
  } finally {
    client.release();
    await pool.end();
  }
}
verify().catch(console.error);"

# Reiniciar o serviço
echo "🔄 Reiniciando o serviço..."
sudo systemctl start relationship-quiz
sudo systemctl status relationship-quiz

# Verificar se o serviço está rodando
echo "✅ Verificando se o serviço está ativo..."
if systemctl is-active --quiet relationship-quiz; then
    echo "🎉 Serviço está rodando corretamente!"
    echo "🌐 Quiz disponível em: http://seu-ip:3000"
else
    echo "❌ Erro: Serviço não está rodando!"
    echo "📋 Logs do serviço:"
    sudo journalctl -u relationship-quiz --no-pager -n 20
    exit 1
fi

echo "✅ Deploy concluído com sucesso!"
echo "📝 Lembre-se de testar o quiz para confirmar que:"
echo "   - A pergunta 24 agora tem 4 opções"
echo "   - O botão 'Next' mostra 'Finish Quiz' na última pergunta"