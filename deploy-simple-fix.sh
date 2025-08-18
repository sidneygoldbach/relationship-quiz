#!/bin/bash

# Script simples para corrigir apenas a pergunta 24 no Kamatera
# Usa as credenciais existentes do sistema

echo "🚀 Corrigindo pergunta 24 no Kamatera..."

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Erro: Execute este script no diretório do projeto!"
    exit 1
fi

# Verificar se o arquivo .env existe
if [ ! -f ".env" ]; then
    echo "❌ Erro: Arquivo .env não encontrado!"
    echo "💡 O aplicativo precisa do arquivo .env com as credenciais do banco."
    exit 1
fi

# Carregar variáveis do .env
source .env

# Verificar se as variáveis necessárias estão definidas
if [ -z "$DB_HOST" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_NAME" ]; then
    echo "❌ Erro: Variáveis de banco não definidas no .env"
    echo "💡 Verifique se DB_HOST, DB_USER, DB_PASSWORD e DB_NAME estão no .env"
    exit 1
fi

echo "🔧 Usando banco: $DB_NAME@$DB_HOST como usuário $DB_USER"

# Testar conexão com banco
echo "🧪 Testando conexão com banco..."
if ! PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1;" > /dev/null 2>&1; then
    echo "❌ Erro: Não foi possível conectar ao banco!"
    echo "💡 Verifique as credenciais no arquivo .env"
    exit 1
fi

echo "✅ Conexão com banco OK!"

# Fazer backup antes da correção
echo "💾 Fazendo backup..."
BACKUP_FILE="backup_question24_$(date +%Y%m%d_%H%M%S).sql"
PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"
echo "📁 Backup salvo em: $BACKUP_FILE"

# Parar o serviço temporariamente
echo "⏸️ Parando o serviço..."
sudo systemctl stop relationship-quiz

# Fazer git pull
echo "📥 Atualizando código..."
git pull origin main

# Executar correção da pergunta 24
echo "🔧 Corrigindo pergunta 24..."
node fix-question24-simple.js

if [ $? -eq 0 ]; then
    echo "✅ Correção aplicada com sucesso!"
else
    echo "❌ Erro na correção!"
    echo "🔄 Reiniciando serviço mesmo assim..."
fi

# Reiniciar o serviço
echo "🔄 Reiniciando o serviço..."
sudo systemctl start relationship-quiz

# Verificar status
echo "📊 Status do serviço:"
sudo systemctl status relationship-quiz --no-pager -l

if systemctl is-active --quiet relationship-quiz; then
    echo "🎉 Serviço está rodando!"
    echo "🌐 Quiz disponível em: http://$(hostname -I | awk '{print $1}'):3000"
else
    echo "❌ Serviço não está rodando!"
    echo "📋 Últimos logs:"
    sudo journalctl -u relationship-quiz --no-pager -n 10
fi

echo "✅ Deploy concluído!"