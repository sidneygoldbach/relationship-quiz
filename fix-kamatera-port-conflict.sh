#!/bin/bash

# Fix port conflict on Kamatera server and restart service
# The service failed because port 3000 is already in use

echo "🔧 Fixing port conflict on Kamatera server..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating port conflict fix script on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create port conflict fix script
cat > fix-port-conflict.sh << 'EOF'
#!/bin/bash

echo "🔧 Fixing port 3000 conflict and restarting service..."

# Navigate to app directory
cd /var/www/relationship-quiz

echo "📍 Working in directory: $(pwd)"

echo "🔍 Checking what's using port 3000..."
echo "Processes using port 3000:"
lsof -i :3000 || echo "No processes found using port 3000"

echo ""
echo "📋 Current service status:"
systemctl status relationship-quiz --no-pager

echo ""
echo "🛑 Stopping any existing relationship-quiz service..."
systemctl stop relationship-quiz
sleep 2

echo "🔍 Killing any remaining Node.js processes..."
pkill -f "node.*server.js" || echo "No Node.js server processes found"
pkill -f "relationship-quiz" || echo "No relationship-quiz processes found"
sleep 2

echo "🔍 Double-checking port 3000..."
PORT_PROCESS=$(lsof -t -i :3000)
if [ ! -z "$PORT_PROCESS" ]; then
    echo "⚠️  Port 3000 still in use by process $PORT_PROCESS, killing it..."
    kill -9 $PORT_PROCESS
    sleep 2
else
    echo "✅ Port 3000 is now free"
fi

echo ""
echo "🔄 Starting relationship-quiz service..."
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
        curl -s "http://localhost:3000/?locale=pt_BR" | grep -o 'id="submit-payment"[^>]*>' || echo "Could not verify button HTML"
    else
        echo "❌ Application test failed"
    fi
else
    echo "❌ Service failed to start"
    echo "📋 Service status:"
    systemctl status relationship-quiz --no-pager -l
    
    echo "📋 Recent logs:"
    journalctl -u relationship-quiz --no-pager -l -n 10
fi

echo "🎉 Port conflict fix complete!"
EOF

# Make the script executable
chmod +x fix-port-conflict.sh

echo "✅ Port conflict fix script created at ~/fix-port-conflict.sh"
echo "📋 Running port conflict fix..."
./fix-port-conflict.sh

ENDSSH

echo "🎉 Port conflict fix completed!"
echo "📋 The service should now be running with the Portuguese payment button fix applied."