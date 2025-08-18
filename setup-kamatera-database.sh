#!/bin/bash

# Script para configurar o banco PostgreSQL no Kamatera
# Execute como root no servidor Kamatera

echo "🔧 Configurando banco PostgreSQL no Kamatera..."

# Verificar se PostgreSQL está instalado
if ! command -v psql &> /dev/null; then
    echo "📦 Instalando PostgreSQL..."
    apt update
    apt install -y postgresql postgresql-contrib
fi

# Iniciar e habilitar PostgreSQL
echo "🚀 Iniciando PostgreSQL..."
systemctl start postgresql
systemctl enable postgresql

# Configurar usuário e banco
echo "👤 Configurando usuário e banco de dados..."
sudo -u postgres psql << EOF
-- Criar usuário se não existir
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'relationshipquiz') THEN
        CREATE USER relationshipquiz WITH PASSWORD 'RelQuiz2024!Secure';
    END IF;
END
\$\$;

-- Criar banco se não existir
SELECT 'CREATE DATABASE relationshipquiz OWNER relationshipquiz'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'relationshipquiz')\gexec

-- Conceder privilégios
GRANT ALL PRIVILEGES ON DATABASE relationshipquiz TO relationshipquiz;

-- Sair
\q
EOF

# Configurar autenticação no pg_hba.conf
echo "🔐 Configurando autenticação..."
PG_VERSION=$(sudo -u postgres psql -t -c "SELECT version()" | grep -oP '\d+\.\d+' | head -1)
PG_HBA_FILE="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"

# Backup do arquivo original
cp "$PG_HBA_FILE" "$PG_HBA_FILE.backup"

# Adicionar linha para autenticação md5 se não existir
if ! grep -q "local.*relationshipquiz.*relationshipquiz.*md5" "$PG_HBA_FILE"; then
    sed -i '/^local.*all.*postgres.*peer/a local   relationshipquiz    relationshipquiz                                md5' "$PG_HBA_FILE"
fi

# Reiniciar PostgreSQL para aplicar mudanças
echo "🔄 Reiniciando PostgreSQL..."
systemctl restart postgresql

# Testar conexão
echo "🧪 Testando conexão..."
if PGPASSWORD='RelQuiz2024!Secure' psql -h localhost -U relationshipquiz -d relationshipquiz -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ Conexão com banco funcionando!"
else
    echo "❌ Erro na conexão com banco"
    exit 1
fi

# Criar arquivo .env se não existir
if [ ! -f "/var/www/relationship-quiz/.env" ]; then
    echo "📝 Criando arquivo .env..."
    cat > /var/www/relationship-quiz/.env << EOF
# Database Configuration
DB_TYPE=postgres
DB_HOST=localhost
DB_PORT=5432
DB_NAME=relationshipquiz
DB_USER=relationshipquiz
DB_PASSWORD=RelQuiz2024!Secure

# Server Configuration
PORT=3000
NODE_ENV=production

# Stripe Configuration (substitua pelas suas chaves)
STRIPE_PUBLISHABLE_KEY=pk_live_your_key_here
STRIPE_SECRET_KEY=sk_live_your_key_here
EOF
    chown www-data:www-data /var/www/relationship-quiz/.env
    chmod 600 /var/www/relationship-quiz/.env
fi

echo "✅ Configuração do banco concluída!"
echo "🔑 Credenciais do banco:"
echo "   Usuário: relationshipquiz"
echo "   Senha: RelQuiz2024!Secure"
echo "   Banco: relationshipquiz"
echo "   Host: localhost"
echo "   Porta: 5432"