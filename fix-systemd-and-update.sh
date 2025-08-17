#!/bin/bash

# Script para corrigir serviço systemd e executar atualização no Kamatera
# Use este script quando o update-kamatera.sh falhar com "Unit relationship-quiz.service not loaded"

echo "🔧 CORREÇÃO DO SERVIÇO SYSTEMD + ATUALIZAÇÃO"
echo "============================================"
echo ""

# 1. Verificar se o serviço systemd existe
echo "🔍 1. Verificando serviço systemd..."
if systemctl list-unit-files | grep -q "relationship-quiz.service"; then
    echo "✅ Serviço systemd encontrado"
else
    echo "❌ Serviço systemd não encontrado - configurando..."
    
    # Copiar arquivo de serviço
    if [ -f "relationship-quiz.service" ]; then
        echo "📋 Copiando arquivo de serviço..."
        sudo cp relationship-quiz.service /etc/systemd/system/
        
        # Recarregar daemon
        echo "🔄 Recarregando systemd daemon..."
        sudo systemctl daemon-reload
        
        # Habilitar serviço
        echo "✅ Habilitando serviço..."
        sudo systemctl enable relationship-quiz
        
        echo "✅ Serviço systemd configurado com sucesso!"
    else
        echo "❌ Arquivo relationship-quiz.service não encontrado!"
        echo "Execute primeiro: git pull origin main"
        exit 1
    fi
fi
echo ""

# 2. Verificar se há processo Node.js rodando na porta 3000
echo "🔍 2. Verificando processos na porta 3000..."
PID=$(lsof -ti:3000)
if [ ! -z "$PID" ]; then
    echo "⚠️  Processo encontrado na porta 3000 (PID: $PID)"
    echo "Parando processo..."
    kill -TERM $PID
    sleep 3
    
    # Verificar se ainda está rodando
    if kill -0 $PID 2>/dev/null; then
        echo "Forçando parada do processo..."
        kill -KILL $PID
    fi
    echo "✅ Processo parado"
else
    echo "✅ Nenhum processo na porta 3000"
fi
echo ""

# 3. Fazer backup do banco de dados
echo "📦 3. Fazendo backup do banco de dados..."
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="quiz_app_backup_${DATE}.sql"

if [ -f ".env" ]; then
    # Carregar variáveis do .env
    export $(grep -v '^#' .env | xargs)
    
    # Usar variáveis de ambiente para backup
    PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"
else
    echo "❌ Arquivo .env não encontrado. Usando configurações padrão..."
    pg_dump -U quiz_user -h localhost quiz_app > "$BACKUP_FILE"
fi

if [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo "✅ Backup criado: $BACKUP_FILE"
else
    echo "❌ Falha no backup! Abortando atualização."
    exit 1
fi
echo ""

# 4. Atualizar código
echo "📥 4. Atualizando código do GitHub..."
git pull origin main
echo ""

# 5. Instalar/atualizar dependências
echo "📦 5. Instalando dependências..."
npm install
echo ""

# 6. Aplicar correções de opções duplicadas
echo "🔧 6. Aplicando correções de opções duplicadas..."

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

# 7. Iniciar serviço
echo "🚀 7. Iniciando serviço..."
sudo systemctl start relationship-quiz

# Aguardar inicialização
echo "⏳ Aguardando inicialização..."
sleep 5

# Verificar status
echo "📊 Status do serviço:"
sudo systemctl status relationship-quiz --no-pager -l
echo ""

# 8. Verificação final
echo "🧪 8. Verificação final..."
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
echo "🎯 ATUALIZAÇÃO CONCLUÍDA!"
echo "========================"
echo "Backup criado: $BACKUP_FILE"
echo "Para verificar status: ./verify-kamatera-fixes.sh"
echo "Para ver logs: sudo journalctl -u relationship-quiz -f"
echo ""