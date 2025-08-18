#!/bin/bash

# Fix SQLite database permissions on Kamatera server
# The service is failing because it cannot open the database file

echo "🗄️ Fixing SQLite database permissions on Kamatera server..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating database fix script on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create database fix script
cat > fix-database.sh << 'EOF'
#!/bin/bash

echo "🗄️ Fixing SQLite database permissions and setup..."

# Navigate to app directory
cd /var/www/relationship-quiz

echo "📍 Working in directory: $(pwd)"

echo "🔍 Checking database files..."
echo "Files in directory:"
ls -la *.db* 2>/dev/null || echo "No .db files found"

echo ""
echo "📋 Checking for quiz_app.db:"
if [ -f "quiz_app.db" ]; then
    echo "✅ quiz_app.db exists"
    echo "File permissions: $(ls -la quiz_app.db)"
    echo "File size: $(du -h quiz_app.db)"
else
    echo "❌ quiz_app.db not found!"
    echo "📋 Looking for database files..."
    find . -name "*.db" -type f 2>/dev/null || echo "No database files found"
fi

echo ""
echo "🔍 Checking directory permissions..."
echo "Directory permissions: $(ls -ld .)"
echo "Owner: $(stat -c '%U:%G' .)"

echo ""
echo "🔧 Fixing permissions..."
# Ensure the app directory is owned by the correct user
chown -R root:root /var/www/relationship-quiz
chmod 755 /var/www/relationship-quiz

# If database exists, fix its permissions
if [ -f "quiz_app.db" ]; then
    chmod 664 quiz_app.db
    echo "✅ Fixed quiz_app.db permissions"
else
    echo "📋 Creating new database file..."
    touch quiz_app.db
    chmod 664 quiz_app.db
    echo "✅ Created new quiz_app.db with correct permissions"
fi

echo ""
echo "🔍 Checking Node.js dependencies..."
if [ -f "package.json" ]; then
    echo "✅ package.json exists"
    if [ -d "node_modules" ]; then
        echo "✅ node_modules exists"
    else
        echo "❌ node_modules missing, running npm install..."
        npm install
    fi
else
    echo "❌ package.json not found!"
fi

echo ""
echo "🧪 Testing database connection..."
node -e "
const Database = require('better-sqlite3');
try {
    const db = new Database('./quiz_app.db');
    console.log('✅ Database connection successful');
    db.close();
} catch (error) {
    console.log('❌ Database connection failed:', error.message);
}
" 2>/dev/null || echo "Could not test database connection (better-sqlite3 may not be installed)"

echo ""
echo "🔄 Attempting to start service..."
systemctl start relationship-quiz
sleep 3

echo "📋 Checking service status..."
if systemctl is-active --quiet relationship-quiz; then
    echo "✅ Service started successfully!"
    
    echo "🧪 Testing application..."
    sleep 2
    curl -s "http://localhost:3000/?locale=pt_BR" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Application is responding!"
        echo "🌐 Portuguese payment button fix is now live!"
        echo "🔗 Test at: http://194.113.194.224:3000/?locale=pt_BR"
        
        echo ""
        echo "🔍 Verifying payment button fix..."
        curl -s "http://localhost:3000/?locale=pt_BR" | grep -A2 -B2 'submit-payment' || echo "Could not verify button HTML"
    else
        echo "❌ Application test failed"
    fi
else
    echo "❌ Service still failed to start"
    echo "📋 Service status:"
    systemctl status relationship-quiz --no-pager -l
    
    echo "📋 Recent logs:"
    journalctl -u relationship-quiz --no-pager -l -n 15
    
    echo ""
    echo "🧪 Testing direct execution..."
    echo "Attempting to run server.js directly for 5 seconds..."
    timeout 5s node server.js 2>&1 || echo "Direct execution failed or timed out"
fi

echo "🎉 Database fix complete!"
EOF

# Make the script executable
chmod +x fix-database.sh

echo "✅ Database fix script created at ~/fix-database.sh"
echo "📋 Running database fix..."
./fix-database.sh

ENDSSH

echo "🎉 Database fix completed!"
echo "📋 The service should now be running with proper database access."