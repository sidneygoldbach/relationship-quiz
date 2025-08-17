#!/bin/bash

# Script para atualizar o servidor Kamatera com as correções de opções duplicadas
# Execute este script no servidor Kamatera

set -e  # Parar em caso de erro

echo "🚀 Iniciando atualização do servidor Kamatera..."
echo "================================================"

# 1. Fazer backup do banco de dados
echo "\n📦 1. Fazendo backup do banco de dados..."
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="relationship_quiz_backup_${DATE}.sql"

# Backup PostgreSQL
echo "Criando backup: $BACKUP_FILE"
pg_dump -h localhost -U relationship_quiz_user -d relationship_quiz > "$BACKUP_FILE"
echo "✅ Backup criado com sucesso: $BACKUP_FILE"

# 2. Parar os serviços
echo "\n🛑 2. Parando serviços..."
sudo systemctl stop relationship-quiz
echo "✅ Serviço relationship-quiz parado"

# 3. Atualizar código do GitHub
echo "\n📥 3. Atualizando código do GitHub..."
cd /var/www/relationship-quiz
git fetch origin
git reset --hard origin/main
echo "✅ Código atualizado com sucesso"

# 4. Instalar dependências (se houver novas)
echo "\n📦 4. Verificando dependências..."
npm install --production
echo "✅ Dependências verificadas"

# 5. Aplicar correções no banco de dados
echo "\n🔧 5. Aplicando correções no banco de dados..."

# Executar script de correção de opções duplicadas
echo "Executando correção de opções duplicadas..."
node diagnose-duplicate-options.js
node fix-duplicate-options.js
node fix-mixed-language-options.js
node remove-remaining-duplicates.js
node add-spanish-options.js
node final-verification.js

echo "✅ Correções aplicadas com sucesso"

# 6. Reiniciar serviços
echo "\n🔄 6. Reiniciando serviços..."
sudo systemctl start relationship-quiz
sudo systemctl enable relationship-quiz
echo "✅ Serviços reiniciados"

# 7. Verificar status
echo "\n🔍 7. Verificando status dos serviços..."
sudo systemctl status relationship-quiz --no-pager

# 8. Teste rápido
echo "\n🧪 8. Testando aplicação..."
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