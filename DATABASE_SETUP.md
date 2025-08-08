# 🗄️ Database Setup Guide

This guide will help you set up PostgreSQL database integration for your Relationship Quiz application.

## 📋 Prerequisites

- Node.js installed
- PostgreSQL installed (or will be installed via setup script)
- Basic command line knowledge

## 🚀 Quick Setup

### Option 1: Automated Setup (Recommended)

```bash
# Run the automated setup script
./setup-database.sh
```

This script will:
- Install PostgreSQL (if not already installed)
- Create the database and user
- Set up proper permissions
- Create/update your .env file
- Test the database connection

### Option 2: Manual Setup

#### 1. Install PostgreSQL

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**macOS (with Homebrew):**
```bash
brew install postgresql
brew services start postgresql
```

**CentOS/RHEL:**
```bash
sudo yum install postgresql-server postgresql-contrib
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### 2. Create Database and User

```bash
# Switch to postgres user and open psql
sudo -u postgres psql
```

```sql
-- Create database
CREATE DATABASE quiz_app;

-- Create user with password
CREATE USER quiz_user WITH ENCRYPTED PASSWORD 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE quiz_app TO quiz_user;

-- Connect to the database
\c quiz_app

-- Grant schema privileges
GRANT ALL ON SCHEMA public TO quiz_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO quiz_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO quiz_user;

-- Exit psql
\q
```

#### 3. Configure Environment Variables

Update your `.env` file with database credentials:

```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=quiz_app
DB_USER=quiz_user
DB_PASSWORD=your_secure_password
```

## 📊 Database Schema

The application automatically creates these tables:

### `quiz_sessions` Table
```sql
CREATE TABLE quiz_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255),
    payment_status VARCHAR(50) DEFAULT 'pending',
    quiz_answers JSONB,
    result_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### `payments` Table
```sql
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) REFERENCES quiz_sessions(session_id),
    stripe_payment_id VARCHAR(255) UNIQUE,
    amount INTEGER NOT NULL,
    currency VARCHAR(3) DEFAULT 'usd',
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔧 API Endpoints

The database integration adds these new endpoints:

### Quiz Management
- `POST /save-quiz-result` - Save quiz answers and results
- `GET /quiz-results/:sessionId` - Retrieve quiz results
- `GET /payment-status/:sessionId` - Check payment status

### Admin Dashboard
- `GET /admin` - Admin dashboard interface
- `GET /admin/stats` - Get quiz statistics

## 📈 Admin Dashboard

Access the admin dashboard at: `http://localhost:3000/admin`

Features:
- 📊 Total quiz sessions
- 💳 Paid sessions count
- 💰 Total revenue
- 📈 Recent activity (24h)
- 🔄 Real-time updates
- 📱 Mobile responsive

## 🧪 Testing Database Connection

```bash
# Test connection using psql
PGPASSWORD=your_password psql -h localhost -U quiz_user -d quiz_app -c "SELECT version();"

# Test via Node.js
node -e "const db = require('./database'); db.pool.query('SELECT NOW()').then(r => console.log('✅ Connected:', r.rows[0])).catch(e => console.error('❌ Error:', e));"
```

## 📝 Useful Database Commands

### Connect to Database
```bash
psql -h localhost -U quiz_user -d quiz_app
```

### View Tables
```sql
\dt
```

### View Quiz Sessions
```sql
SELECT id, session_id, email, payment_status, result_type, created_at 
FROM quiz_sessions 
ORDER BY created_at DESC 
LIMIT 10;
```

### View Payments
```sql
SELECT id, session_id, stripe_payment_id, amount, status, created_at 
FROM payments 
ORDER BY created_at DESC 
LIMIT 10;
```

### Get Revenue Statistics
```sql
SELECT 
    COUNT(*) as total_sessions,
    COUNT(CASE WHEN payment_status = 'completed' THEN 1 END) as paid_sessions,
    SUM(CASE WHEN p.status = 'succeeded' THEN p.amount ELSE 0 END) as total_revenue
FROM quiz_sessions qs
LEFT JOIN payments p ON qs.session_id = p.session_id;
```

## 🔒 Security Best Practices

1. **Strong Passwords**: Use complex passwords for database users
2. **Environment Variables**: Never commit database credentials to version control
3. **Network Security**: Restrict database access to localhost only
4. **Regular Backups**: Set up automated database backups
5. **SSL Connections**: Enable SSL for production databases

## 🔧 Troubleshooting

### Common Issues

**Connection Refused:**
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL if not running
sudo systemctl start postgresql
```

**Authentication Failed:**
```bash
# Reset user password
sudo -u postgres psql -c "ALTER USER quiz_user PASSWORD 'new_password';"
```

**Permission Denied:**
```bash
# Grant all privileges again
sudo -u postgres psql -d quiz_app -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO quiz_user;"
```

**Database Does Not Exist:**
```bash
# Recreate database
sudo -u postgres createdb quiz_app
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE quiz_app TO quiz_user;"
```

## 📦 Backup and Restore

### Create Backup
```bash
pg_dump -h localhost -U quiz_user -d quiz_app > quiz_app_backup.sql
```

### Restore Backup
```bash
psql -h localhost -U quiz_user -d quiz_app < quiz_app_backup.sql
```

## 🚀 Production Deployment

For production deployment:

1. **Use managed database services** (AWS RDS, Google Cloud SQL, etc.)
2. **Enable SSL connections**
3. **Set up connection pooling**
4. **Configure automated backups**
5. **Monitor database performance**
6. **Use environment-specific credentials**

## 📞 Support

If you encounter issues:

1. Check the server logs for error messages
2. Verify database connection settings
3. Ensure PostgreSQL service is running
4. Test database connectivity manually
5. Check firewall settings

## 🔄 Migration and Updates

The database schema is automatically initialized when the server starts. For future updates:

1. Database migrations will be handled automatically
2. Existing data will be preserved
3. New tables/columns will be added as needed
4. Always backup before major updates

---

**Need help?** Check the server logs or contact support with specific error messages.