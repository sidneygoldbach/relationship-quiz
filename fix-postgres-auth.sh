#!/bin/bash

# Script para corrigir autenticação do PostgreSQL no Kamatera

echo "🔧 Corrigindo configuração do PostgreSQL..."

# Verificar se PostgreSQL está rodando
if ! sudo systemctl is-active --quiet postgresql; then
    echo "🚀 Iniciando PostgreSQL..."
    sudo systemctl start postgresql
    sleep 3
fi

# Verificar se o banco existe
echo "🔍 Verificando banco de dados..."
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw relationship_quiz; then
    echo "✅ Banco 'relationship_quiz' encontrado"
else
    echo "❌ Banco 'relationship_quiz' não encontrado"
    echo "📋 Criando banco de dados..."
    sudo -u postgres createdb relationship_quiz
fi

# Verificar se o usuário existe
echo "🔍 Verificando usuário do banco..."
if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='relationship_quiz_user'" | grep -q 1; then
    echo "✅ Usuário 'relationship_quiz_user' encontrado"
else
    echo "❌ Usuário 'relationship_quiz_user' não encontrado"
    echo "👤 Criando usuário..."
    sudo -u postgres psql -c "CREATE USER relationship_quiz_user WITH PASSWORD 'sua_senha_aqui';"
fi

# Conceder permissões
echo "🔐 Configurando permissões..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE relationship_quiz TO relationship_quiz_user;"
sudo -u postgres psql -d relationship_quiz -c "GRANT ALL ON SCHEMA public TO relationship_quiz_user;"
sudo -u postgres psql -d relationship_quiz -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO relationship_quiz_user;"
sudo -u postgres psql -d relationship_quiz -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO relationship_quiz_user;"

# Verificar arquivo .env
echo "📄 Verificando arquivo .env..."
if [ ! -f ".env" ]; then
    echo "❌ Arquivo .env não encontrado"
    echo "📋 Criando arquivo .env..."
    cat > .env << EOF
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=relationship_quiz
DB_USER=relationship_quiz_user
DB_PASSWORD=sua_senha_aqui
EOF
    echo "✅ Arquivo .env criado"
    echo "⚠️  IMPORTANTE: Edite o arquivo .env e defina a senha correta!"
else
    echo "✅ Arquivo .env encontrado"
fi

# Testar conexão
echo "🧪 Testando conexão com o banco..."
if PGPASSWORD=$(grep DB_PASSWORD .env | cut -d'=' -f2) psql -h localhost -U relationship_quiz_user -d relationship_quiz -c "SELECT version();" > /dev/null 2>&1; then
    echo "✅ Conexão com banco funcionando!"
else
    echo "❌ Falha na conexão com o banco"
    echo "📋 Possíveis soluções:"
    echo "   1. Verifique a senha no arquivo .env"
    echo "   2. Execute: sudo -u postgres psql -c \"ALTER USER relationship_quiz_user PASSWORD 'nova_senha';\""
    echo "   3. Atualize a senha no arquivo .env"
fi

echo ""
echo "✅ Script de correção concluído!"
echo "📋 Próximos passos:"
echo "   1. Verifique/edite o arquivo .env com a senha correta"
echo "   2. Execute novamente: ./update-kamatera.sh"