#!/bin/bash

# Script para forçar a correção de opções duplicadas no Kamatera
# Use este script se ainda houver opções duplicadas após a atualização

echo "🔧 CORREÇÃO FORÇADA DE OPÇÕES DUPLICADAS"
echo "========================================"
echo ""

# Verificar se arquivo .env existe
if [ ! -f ".env" ]; then
    echo "❌ Arquivo .env não encontrado!"
    echo "Execute primeiro: ./fix-postgres-auth.sh"
    exit 1
fi

# Carregar variáveis do .env
export $(grep -v '^#' .env | xargs)

# 1. Parar serviços
echo "🛑 1. Parando serviços..."
sudo systemctl stop relationship-quiz
echo ""

# 2. Fazer backup antes da correção
echo "📦 2. Fazendo backup de segurança..."
BACKUP_FILE="emergency_backup_$(date +%Y%m%d_%H%M%S).sql"
PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"
echo "✅ Backup salvo em: $BACKUP_FILE"
echo ""

# 3. Executar scripts de correção em sequência
echo "🔧 3. Aplicando correções..."

echo "   → Diagnosticando opções duplicadas..."
node diagnose-duplicate-options.js

echo "   → Removendo opções duplicadas..."
node fix-duplicate-options.js

echo "   → Corrigindo idiomas misturados..."
node fix-mixed-language-options.js

echo "   → Removendo duplicatas restantes..."
node remove-remaining-duplicates.js

echo "   → Adicionando opções em espanhol..."
node add-spanish-options.js

echo "   → Verificação final..."
node final-verification.js

echo ""

# 4. Verificar resultado
echo "🔍 4. Verificando resultado..."
echo "Contagem final de opções:"
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
    SELECT 
        language,
        COUNT(*) as total_options
    FROM quiz_options 
    GROUP BY language 
    ORDER BY language;
"

echo ""
echo "Verificando duplicatas:"
DUPLICATES=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -t -c "
    SELECT COUNT(*) 
    FROM (
        SELECT text, language, COUNT(*) 
        FROM quiz_options 
        GROUP BY text, language 
        HAVING COUNT(*) > 1
    ) duplicates;
")

DUPLICATES=$(echo $DUPLICATES | tr -d ' ')

if [ "$DUPLICATES" = "0" ]; then
    echo "✅ Correção bem-sucedida! Nenhuma duplicata encontrada."
else
    echo "❌ Ainda existem $DUPLICATES opções duplicadas."
    echo "Listando duplicatas restantes:"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
        SELECT text, language, COUNT(*) as duplicates
        FROM quiz_options 
        GROUP BY text, language 
        HAVING COUNT(*) > 1
        ORDER BY COUNT(*) DESC;
    "
fi
echo ""

# 5. Reiniciar serviços
echo "🔄 5. Reiniciando serviços..."
sudo systemctl start relationship-quiz
sudo systemctl status relationship-quiz --no-pager -l
echo ""

# 6. Teste final
echo "🧪 6. Teste final da aplicação..."
sleep 5  # Aguardar inicialização

if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Aplicação está funcionando!"
    
    # Testar API
    if curl -s http://localhost:3000/api/quiz/questions > /dev/null; then
        echo "✅ API do quiz está respondendo!"
    else
        echo "⚠️  API do quiz não está respondendo"
    fi
else
    echo "❌ Aplicação não está respondendo"
    echo "Verificando logs:"
    sudo journalctl -u relationship-quiz --no-pager -l -n 10
fi

echo ""
echo "🎯 CORREÇÃO CONCLUÍDA!"
echo "====================="
echo "Backup de segurança: $BACKUP_FILE"
echo "Para verificar status: ./verify-kamatera-fixes.sh"
echo "Para ver logs: sudo journalctl -u relationship-quiz -f"
echo ""