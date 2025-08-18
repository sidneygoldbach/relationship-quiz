#!/bin/bash

# Script para corrigir pergunta 24 no Kamatera (compatível com estrutura real do banco)

echo "🔧 Corrigindo pergunta 24 no Kamatera..."

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
BACKUP_FILE="backup_question24_$(date +%Y%m%d_%H%M%S).sql"
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

# Executar script de correção compatível
echo "🔧 Corrigindo pergunta 24..."
node fix-question24-kamatera-compatible.js

CORRECTION_STATUS=$?

if [ $CORRECTION_STATUS -eq 0 ]; then
    echo "✅ Correção aplicada com sucesso!"
else
    echo "❌ Erro na correção!"
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

# Verificar correções no banco
echo "🔍 Verificando correções no banco..."
PGPASSWORD="${DB_PASSWORD:-quiz_password_2024}" psql -h "${DB_HOST:-localhost}" -U "${DB_USER:-quiz_user}" -d "${DB_NAME:-quiz_app}" -c "
SELECT 
    'Pergunta 24 - Opções:' as info,
    COUNT(*) as total_opcoes
FROM answer_options 
WHERE question_id = 24;
" 2>/dev/null

echo "✅ Deploy concluído!"
echo ""
echo "📋 Próximos passos:"
echo "  1. Teste o quiz em: http://$(curl -s ifconfig.me):3000"
echo "  2. Verifique se a última pergunta tem 4 opções"
echo "  3. Confirme se o botão 'Finish Quiz' aparece corretamente"
echo ""
echo "🔍 Para verificar logs em tempo real:"
echo "  sudo journalctl -u relationship-quiz -f"