#!/bin/bash

# PostgreSQL Setup Script for Quiz Application
# This script helps set up PostgreSQL database for the relationship quiz app

echo "🗄️  Setting up PostgreSQL for Quiz Application..."
echo "================================================"

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Installing..."
    
    # Detect OS and install PostgreSQL
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y postgresql postgresql-contrib
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
        # CentOS/RHEL
        elif command -v yum &> /dev/null; then
            sudo yum install -y postgresql-server postgresql-contrib
            sudo postgresql-setup initdb
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install postgresql
            brew services start postgresql
        else
            echo "❌ Homebrew not found. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    fi
else
    echo "✅ PostgreSQL is already installed"
fi

# Check if PostgreSQL service is running
if ! pgrep -x "postgres" > /dev/null; then
    echo "🔄 Starting PostgreSQL service..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo systemctl start postgresql
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew services start postgresql
    fi
fi

echo "📝 Setting up database and user..."

# Create database and user
sudo -u postgres psql << EOF
-- Create database
CREATE DATABASE quiz_app;

-- Create user
CREATE USER quiz_user WITH ENCRYPTED PASSWORD 'quiz_password_2024';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE quiz_app TO quiz_user;

-- Grant schema privileges
\c quiz_app
GRANT ALL ON SCHEMA public TO quiz_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO quiz_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO quiz_user;

-- Show databases
\l

-- Exit
\q
EOF

echo "📋 Creating .env file..."

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "✅ Created .env file from .env.example"
    echo "⚠️  Please update your Stripe keys in .env file"
else
    echo "⚠️  .env file already exists. Please manually add database configuration:"
fi

echo ""
echo "📝 Add these database settings to your .env file:"
echo "DB_HOST=localhost"
echo "DB_PORT=5432"
echo "DB_NAME=quiz_app"
echo "DB_USER=quiz_user"
echo "DB_PASSWORD=quiz_password_2024"
echo ""

echo "🧪 Testing database connection..."

# Test database connection
PGPASSWORD=quiz_password_2024 psql -h localhost -U quiz_user -d quiz_app -c "SELECT version();" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Database connection successful!"
else
    echo "❌ Database connection failed. Please check the setup."
    echo "💡 Try running: sudo -u postgres psql"
    echo "   Then manually create the database and user."
fi

echo ""
echo "🚀 Setup complete! Next steps:"
echo "1. Update your .env file with correct Stripe keys"
echo "2. Run: npm install"
echo "3. Run: node server.js"
echo "4. Visit: http://localhost:3000/admin/stats to see database stats"
echo ""
echo "📚 Useful PostgreSQL commands:"
echo "   Connect to database: psql -h localhost -U quiz_user -d quiz_app"
echo "   View tables: \dt"
echo "   View quiz sessions: SELECT * FROM quiz_sessions;"
echo "   View payments: SELECT * FROM payments;"
echo ""