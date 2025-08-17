#!/bin/bash

# Script para verificar se as correções foram aplicadas no servidor Kamatera
# Este script deve ser executado no servidor Kamatera após a atualização

echo "🔍 VERIFICAÇÃO DAS CORREÇÕES NO KAMATERA"
echo "==========================================="
echo ""

# 1. Verificar versão do código (último commit)
echo "📋 1. Verificando versão do código..."
echo "Último commit:"
git log -1 --oneline
echo "Branch atual:"
git branch --show-current
echo ""

# 2. Verificar status dos serviços
echo "🔧 2. Verificando status dos serviços..."
echo "Status do serviço relationship-quiz:"
sudo systemctl status relationship-quiz --no-pager -l
echo ""
echo "Status do PostgreSQL:"
sudo systemctl status postgresql --no-pager -l
echo ""

# 3. Verificar conexão com banco de dados
echo "🗄️  3. Verificando conexão com banco de dados..."
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
    if PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();" > /dev/null 2>&1; then
        echo "✅ Conexão com banco de dados OK"
    else
        echo "❌ Falha na conexão com banco de dados"
        echo "Verifique as configurações no arquivo .env"
    fi
else
    echo "❌ Arquivo .env não encontrado"
fi
echo ""

# 4. Verificar opções duplicadas
echo "🔍 4. Verificando opções duplicadas..."
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
    
    echo "Contando opções por idioma:"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
        SELECT 
            language,
            COUNT(*) as total_options
        FROM quiz_options 
        GROUP BY language 
        ORDER BY language;
    "
    
    echo ""
    echo "Verificando opções duplicadas:"
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
        echo "✅ Nenhuma opção duplicada encontrada!"
    else
        echo "❌ Encontradas $DUPLICATES opções duplicadas:"
        PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "
            SELECT text, language, COUNT(*) as duplicates
            FROM quiz_options 
            GROUP BY text, language 
            HAVING COUNT(*) > 1
            ORDER BY COUNT(*) DESC;
        "
    fi
else
    echo "❌ Não foi possível verificar - arquivo .env não encontrado"
fi
echo ""

# 5. Verificar se aplicação está respondendo
echo "🌐 5. Verificando se aplicação está respondendo..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Aplicação está respondendo na porta 3000"
    
    # Testar endpoint específico do quiz
    if curl -s http://localhost:3000/api/quiz/questions > /dev/null; then
        echo "✅ API do quiz está funcionando"
    else
        echo "⚠️  API do quiz não está respondendo"
    fi
else
    echo "❌ Aplicação não está respondendo na porta 3000"
    echo "Verifique os logs:"
    sudo journalctl -u relationship-quiz --no-pager -l --since "10 minutes ago"
fi
echo ""

# 6. Verificar logs recentes
echo "📋 6. Logs recentes da aplicação (últimos 20 linhas):"
sudo journalctl -u relationship-quiz --no-pager -l -n 20
echo ""

# 7. Resumo final
echo "📊 RESUMO DA VERIFICAÇÃO"
echo "========================"
echo "✅ = OK | ❌ = Problema | ⚠️  = Atenção"
echo ""
echo "Para corrigir problemas encontrados:"
echo "1. Se há opções duplicadas: execute ./remove-remaining-duplicates.js"
echo "2. Se serviço não está rodando: sudo systemctl restart relationship-quiz"
echo "3. Se aplicação não responde: verifique logs com 'sudo journalctl -u relationship-quiz -f'"
echo "4. Se banco não conecta: execute ./fix-postgres-auth.sh"
echo ""
echo "🔄 Para aplicar correções novamente: ./update-kamatera.sh"
echo ""