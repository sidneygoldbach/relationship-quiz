#!/bin/bash

# Force restart Kamatera service by killing all processes on port 3000
# and ensuring clean service restart

echo "🔧 Force restarting Kamatera service..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating force restart script on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create force restart script
cat > force-restart.sh << 'EOF'
#!/bin/bash

echo "🔧 Force restarting relationship-quiz service..."

# Navigate to app directory
cd /var/www/relationship-quiz

echo "📍 Working in directory: $(pwd)"

echo "🛑 Step 1: Stopping systemd service..."
systemctl stop relationship-quiz
systemctl disable relationship-quiz
sleep 2

echo "🔍 Step 2: Finding all processes using port 3000..."
echo "Processes on port 3000:"
lsof -i :3000

echo ""
echo "🔪 Step 3: Killing ALL processes on port 3000..."
# Kill by port
fuser -k 3000/tcp 2>/dev/null || echo "No processes found on port 3000"
sleep 2

# Kill any remaining Node.js processes
echo "🔪 Step 4: Killing Node.js processes..."
pkill -f "node.*server.js" || echo "No Node.js server processes found"
pkill -f "relationship-quiz" || echo "No relationship-quiz processes found"
pkill -9 -f "node.*server.js" || echo "No Node.js processes to force kill"
sleep 3

echo "🔍 Step 5: Verifying port 3000 is free..."
PORT_CHECK=$(lsof -i :3000)
if [ -z "$PORT_CHECK" ]; then
    echo "✅ Port 3000 is now completely free"
else
    echo "⚠️  Port 3000 still has processes:"
    echo "$PORT_CHECK"
    echo "🔪 Force killing remaining processes..."
    lsof -t -i :3000 | xargs -r kill -9
    sleep 2
fi

echo ""
echo "🔄 Step 6: Re-enabling and starting service..."
systemctl enable relationship-quiz
systemctl start relationship-quiz

echo "⏳ Waiting 5 seconds for service to start..."
sleep 5

echo "📋 Step 7: Checking service status..."
if systemctl is-active --quiet relationship-quiz; then
    echo "✅ Service is running!"
    
    echo "🧪 Testing application..."
    sleep 2
    
    # Test with curl
    CURL_RESULT=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000/?locale=pt_BR")
    
    if [ "$CURL_RESULT" = "200" ]; then
        echo "✅ Application is responding with HTTP 200!"
        echo "🌐 Portuguese payment button fix is now live!"
        echo "🔗 Test at: http://194.113.194.224:3000/?locale=pt_BR"
        
        echo ""
        echo "🔍 Verifying payment button fix..."
        BUTTON_CHECK=$(curl -s "http://localhost:3000/?locale=pt_BR" | grep -o 'id="submit-payment"[^>]*data-i18n[^>]*>')
        if [ ! -z "$BUTTON_CHECK" ]; then
            echo "✅ Payment button has data-i18n attribute: $BUTTON_CHECK"
        else
            echo "⚠️  Could not verify data-i18n attribute on payment button"
        fi
    else
        echo "❌ Application returned HTTP $CURL_RESULT"
    fi
    
    echo ""
    echo "📊 Final service status:"
    systemctl status relationship-quiz --no-pager -l
else
    echo "❌ Service failed to start"
    echo "📋 Service status:"
    systemctl status relationship-quiz --no-pager -l
    
    echo "📋 Recent logs:"
    journalctl -u relationship-quiz --no-pager -l -n 20
    
    echo ""
    echo "🔍 Checking what's still on port 3000:"
    lsof -i :3000 || echo "Nothing on port 3000"
fi

echo "🎉 Force restart complete!"
EOF

# Make the script executable
chmod +x force-restart.sh

echo "✅ Force restart script created at ~/force-restart.sh"
echo "📋 Running force restart..."
./force-restart.sh

ENDSSH

echo "🎉 Force restart completed!"
echo "📋 The service should now be running cleanly with the Portuguese payment button fix."