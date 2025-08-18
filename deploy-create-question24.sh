#!/bin/bash

# Script para criar pergunta 24 no Kamatera

echo "🔧 Criando pergunta 24 no Kamatera..."

# Verificar se estamos no diretório correto
if [ ! -f "server.js" ]; then
    echo "❌ Erro: Execute este script no diretório do projeto!"
    exit 1
fi

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "❌ Erro: Arquivo .env não encontrado!"
    echo "💡 Certifique-se de que as variáveis de ambiente do banco estão configuradas."
    exit 1
fi

echo "📋 Verificando variáveis de ambiente do banco..."
source .env
echo "  - DB_HOST: ${DB_HOST:-localhost}"
echo "  - DB_NAME: ${DB_NAME:-quiz_app}"
echo "  - DB_USER: ${DB_USER:-quiz_user}"

# Testar conexão com banco
echo "🔍 Testando conexão com banco de dados..."
PGPASSWORD="${DB_PASSWORD:-quiz_password_2024}" psql -h "${DB_HOST:-localhost}" -U "${DB_USER:-quiz_user}" -d "${DB_NAME:-quiz_app}" -c "SELECT version();" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "❌ Erro: Não foi possível conectar ao banco de dados!"
    echo "💡 Verifique as credenciais no arquivo .env"
    exit 1
fi

echo "✅ Conexão com banco OK!"

# Fazer backup do banco
echo "💾 Fazendo backup..."
BACKUP_FILE="backup_create_question24_$(date +%Y%m%d_%H%M%S).sql"
PGPASSWORD="${DB_PASSWORD:-quiz_password_2024}" pg_dump -h "${DB_HOST:-localhost}" -U "${DB_USER:-quiz_user}" -d "${DB_NAME:-quiz_app}" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "📁 Backup salvo em: $BACKUP_FILE"
else
    echo "⚠️ Aviso: Não foi possível fazer backup, mas continuando..."
fi

# Parar o serviço
echo "⏸️ Parando o serviço..."
sudo systemctl stop relationship-quiz

# Atualizar código
echo "📥 Atualizando código..."
git pull origin main

# Instalar dependências (se necessário)
if [ -f "package.json" ]; then
    echo "📦 Verificando dependências..."
    npm install --production
fi

# Executar script de criação da pergunta 24
echo "🔧 Criando pergunta 24..."
node create-question24-kamatera.js

CREATION_STATUS=$?

if [ $CREATION_STATUS -eq 0 ]; then
    echo "✅ Pergunta 24 criada com sucesso!"
else
    echo "❌ Erro na criação da pergunta 24!"
fi

# Reiniciar serviço
echo "🔄 Reiniciando o serviço..."
sudo systemctl start relationship-quiz

# Verificar status
echo "📊 Status do serviço:"
sudo systemctl status relationship-quiz --no-pager

# Verificar se está rodando
if systemctl is-active --quiet relationship-quiz; then
    echo "🎉 Serviço está rodando!"
    echo "🌐 Quiz disponível em: http://$(curl -s ifconfig.me):3000"
else
    echo "❌ Serviço não está rodando!"
    echo "🔍 Verifique os logs: sudo journalctl -u relationship-quiz -f"
fi

# Verificar resultado no banco
echo "🔍 Verificando pergunta 24 no banco..."
PGPASSWORD="${DB_PASSWORD:-quiz_password_2024}" psql -h "${DB_HOST:-localhost}" -U "${DB_USER:-quiz_user}" -d "${DB_NAME:-quiz_app}" -c "
SELECT 
    'Pergunta 24:' as info,
    question_text
FROM questions 
WHERE id = 24;

SELECT 
    'Opções da pergunta 24:' as info,
    COUNT(*) as total_opcoes
FROM answer_options 
WHERE question_id = 24;

SELECT 
    'Lista de opções:' as info,
    option_text
FROM answer_options 
WHERE question_id = 24 
ORDER BY option_order;
" 2>/dev/null

echo "✅ Deploy concluído!"
echo ""
echo "📋 Próximos passos:"
echo "  1. Teste o quiz em: http://$(curl -s ifconfig.me):3000"
echo "  2. Verifique se a pergunta 24 aparece com 4 opções"
echo "  3. Confirme se o botão 'Finish Quiz' aparece corretamente"
echo ""
echo "🔍 Para verificar logs em tempo real:"
echo "  sudo journalctl -u relationship-quiz -f"