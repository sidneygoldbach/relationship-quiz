#!/bin/bash

# Diagnose Kamatera service failure after payment fix
# This script will help identify why the service failed to restart

echo "🔍 Diagnosing Kamatera service failure..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating diagnostic script on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create diagnostic script
cat > diagnose-service.sh << 'EOF'
#!/bin/bash

echo "🔍 Diagnosing relationship-quiz service failure..."

# Navigate to app directory
cd /var/www/relationship-quiz

echo "📍 Current directory: $(pwd)"
echo "📋 Files in directory:"
ls -la

echo ""
echo "🔧 Checking Node.js and dependencies..."
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

echo ""
echo "📋 Checking package.json:"
if [ -f "package.json" ]; then
    echo "✅ package.json exists"
    cat package.json
else
    echo "❌ package.json not found!"
fi

echo ""
echo "📋 Checking server.js:"
if [ -f "server.js" ]; then
    echo "✅ server.js exists"
    echo "First 20 lines of server.js:"
    head -20 server.js
else
    echo "❌ server.js not found!"
fi

echo ""
echo "📋 Checking node_modules:"
if [ -d "node_modules" ]; then
    echo "✅ node_modules exists"
    echo "Size: $(du -sh node_modules)"
else
    echo "❌ node_modules not found! Need to run npm install"
fi

echo ""
echo "🔍 Checking recent index.html changes:"
echo "Last 10 lines of index.html:"
tail -10 index.html

echo ""
echo "📋 Service status:"
systemctl status relationship-quiz --no-pager -l

echo ""
echo "📋 Recent service logs:"
journalctl -u relationship-quiz --no-pager -l -n 20

echo ""
echo "🧪 Testing Node.js directly:"
echo "Attempting to run server.js directly..."
timeout 10s node server.js 2>&1 || echo "Direct execution failed or timed out"

echo ""
echo "📋 Checking for syntax errors in index.html:"
if command -v tidy >/dev/null 2>&1; then
    echo "Running HTML validation..."
    tidy -q -e index.html 2>&1 || echo "HTML validation completed with warnings/errors"
else
    echo "tidy not available, checking for basic syntax issues..."
    grep -n "<button.*>.*</button>" index.html | head -5
fi

echo ""
echo "🔄 Checking if backup exists:"
ls -la index.html.backup.* 2>/dev/null || echo "No backup files found"

echo ""
echo "🎯 Diagnosis complete!"
EOF

# Make diagnostic script executable
chmod +x diagnose-service.sh

echo "✅ Diagnostic script created at ~/diagnose-service.sh"
echo "📋 Running diagnosis..."
./diagnose-service.sh

ENDSSH

echo "🎉 Diagnosis complete! Check the output above for service failure details."},"query_language":"Portuguese"}}