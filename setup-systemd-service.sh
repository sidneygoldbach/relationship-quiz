#!/bin/bash

# Script para configurar o serviço systemd do Relationship Quiz no Kamatera

echo "🔧 Configurando serviço systemd para Relationship Quiz..."

# Verificar se estamos no diretório correto
if [ ! -f "server.js" ]; then
    echo "❌ Erro: Execute este script no diretório da aplicação (/var/www/relationship-quiz)"
    exit 1
fi

# Verificar se o arquivo de serviço existe
if [ ! -f "relationship-quiz.service" ]; then
    echo "❌ Erro: Arquivo relationship-quiz.service não encontrado"
    echo "Execute 'git pull origin main' primeiro para baixar o arquivo"
    exit 1
fi

# Parar serviço se estiver rodando
echo "🛑 Parando serviço existente (se houver)..."
sudo systemctl stop relationship-quiz 2>/dev/null || true

# Copiar arquivo de serviço
echo "📋 Copiando arquivo de serviço..."
sudo cp relationship-quiz.service /etc/systemd/system/

# Recarregar systemd
echo "🔄 Recarregando systemd..."
sudo systemctl daemon-reload

# Habilitar serviço para iniciar automaticamente
echo "✅ Habilitando serviço..."
sudo systemctl enable relationship-quiz

# Iniciar serviço
echo "🚀 Iniciando serviço..."
sudo systemctl start relationship-quiz

# Verificar status
echo "🔍 Verificando status..."
sudo systemctl status relationship-quiz --no-pager

echo ""
echo "✅ Configuração do serviço systemd concluída!"
echo ""
echo "📋 Comandos úteis:"
echo "  - Ver status: sudo systemctl status relationship-quiz"
echo "  - Ver logs: sudo journalctl -u relationship-quiz -f"
echo "  - Reiniciar: sudo systemctl restart relationship-quiz"
echo "  - Parar: sudo systemctl stop relationship-quiz"
echo "  - Iniciar: sudo systemctl start relationship-quiz"