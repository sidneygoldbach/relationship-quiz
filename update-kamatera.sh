#!/bin/bash

# Script para atualizar o servidor Kamatera com as correções de opções duplicadas
# Execute este script no servidor Kamatera

set -e  # Parar em caso de erro

echo "🚀 Iniciando atualização do servidor Kamatera..."
echo "================================================"

# 1. Verificar configuração do banco de dados
echo "\n🔍 1. Verificando configuração do banco de dados..."
if [ ! -f ".env" ]; then
    echo "❌ Arquivo .env não encontrado. Execute ./fix-postgres-auth.sh primeiro"
    exit 1
fi

# Carregar variáveis do .env
source .env

# 2. Fazer backup do banco de dados
echo "\n📦 2. Fazendo backup do banco de dados..."
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="relationship_quiz_backup_${DATE}.sql"

# Backup PostgreSQL
echo "Criando backup: $BACKUP_FILE"
PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"
if [ $? -eq 0 ]; then
    echo "✅ Backup criado com sucesso: $BACKUP_FILE"
else
    echo "❌ Erro ao criar backup. Execute ./fix-postgres-auth.sh para corrigir"
    echo "Continuando mesmo assim..."
fi

# 3. Parar os serviços
echo "\n🛑 3. Parando serviços..."
sudo systemctl stop relationship-quiz
echo "✅ Serviço relationship-quiz parado"

# 4. Atualizar código do GitHub
echo "\n📥 4. Atualizando código do GitHub..."
cd /var/www/relationship-quiz
git fetch origin
git reset --hard origin/main
echo "✅ Código atualizado com sucesso"

# 5. Instalar dependências (se houver novas)
echo "\n📦 5. Verificando dependências..."
npm install --production
echo "✅ Dependências verificadas"

# 6. Configurar serviço systemd
echo "\n⚙️ 6. Configurando serviço systemd..."
# Copiar arquivo de serviço para systemd
sudo cp relationship-quiz.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable relationship-quiz
echo "✅ Serviço systemd configurado"

# 7. Aplicar correções no banco de dados
echo "\n🔧 7. Aplicando correções no banco de dados..."

# Executar script de correção de opções duplicadas
echo "Executando correção de opções duplicadas..."
node diagnose-duplicate-options.js
node fix-duplicate-options.js
node fix-mixed-language-options.js
node remove-remaining-duplicates.js
node add-spanish-options.js
node final-verification.js

echo "✅ Correções aplicadas com sucesso"

# 8. Reiniciar serviços
echo "\n🔄 8. Reiniciando serviços..."
sudo systemctl start relationship-quiz
sudo systemctl enable relationship-quiz
echo "✅ Serviços reiniciados"

# 9. Verificar status
echo "\n🔍 9. Verificando status dos serviços..."
sudo systemctl status relationship-quiz --no-pager

# 10. Teste rápido
echo "\n🧪 10. Testando aplicação..."
sleep 5
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 || echo "000")

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Aplicação está respondendo corretamente (HTTP $HTTP_STATUS)"
else
    echo "⚠️ Aplicação pode ter problemas (HTTP $HTTP_STATUS)"
    echo "Verificando logs..."
    sudo journalctl -u relationship-quiz --no-pager -n 20
fi

echo "\n🎉 Atualização concluída!"
echo "================================================"
echo "📋 Resumo:"
echo "  - Backup criado: $BACKUP_FILE"
echo "  - Código atualizado do GitHub"
echo "  - Correções de opções duplicadas aplicadas"
echo "  - Serviços reiniciados"
echo "  - Status HTTP: $HTTP_STATUS"
echo "\n💡 Para verificar logs em tempo real:"
echo "   sudo journalctl -u relationship-quiz -f"
echo "\n🌐 Acesse: http://seu-servidor-ip:3000"