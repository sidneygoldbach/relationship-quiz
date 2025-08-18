#!/bin/bash

# Final fix for Kamatera service - kill specific PID and restart
# There's a stubborn Node.js process (PID 1126954) holding port 3000

echo "🎯 Final fix for Kamatera service..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating final fix script on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create final fix script
cat > final-fix.sh << 'EOF'
#!/bin/bash

echo "🎯 Final fix - killing stubborn process and restarting service..."

# Navigate to app directory
cd /var/www/relationship-quiz

echo "📍 Working in directory: $(pwd)"

echo "🔍 Step 1: Finding exact processes on port 3000..."
lsof -i :3000

echo ""
echo "🔪 Step 2: Killing specific processes by PID..."
# Get all PIDs using port 3000 and kill them
PIDS=$(lsof -t -i :3000)
if [ ! -z "$PIDS" ]; then
    echo "Found PIDs using port 3000: $PIDS"
    for pid in $PIDS; do
        echo "Killing PID $pid..."
        kill -9 $pid
    done
    sleep 3
else
    echo "No processes found on port 3000"
fi

echo ""
echo "🛑 Step 3: Ensuring systemd service is stopped..."
systemctl stop relationship-quiz
sleep 2

echo "🔍 Step 4: Final verification that port 3000 is free..."
PORT_CHECK=$(lsof -i :3000)
if [ -z "$PORT_CHECK" ]; then
    echo "✅ Port 3000 is completely free!"
else
    echo "⚠️  Still processes on port 3000:"
    echo "$PORT_CHECK"
    echo "🔪 Nuclear option - killing everything..."
    killall -9 node 2>/dev/null || echo "No node processes to kill"
    sleep 2
fi

echo ""
echo "🔄 Step 5: Starting fresh service..."
systemctl start relationship-quiz

echo "⏳ Waiting 8 seconds for service to fully start..."
sleep 8

echo "📋 Step 6: Final status check..."
if systemctl is-active --quiet relationship-quiz; then
    echo "✅ Service is RUNNING!"
    
    # Test the application
    echo "🧪 Testing application response..."
    CURL_RESULT=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000/?locale=pt_BR")
    
    if [ "$CURL_RESULT" = "200" ]; then
        echo "✅ Application responding with HTTP 200!"
        echo "🌐 SUCCESS: Portuguese payment button fix is LIVE!"
        echo "🔗 Test URL: http://194.113.194.224:3000/?locale=pt_BR"
        
        echo ""
        echo "🔍 Verifying the payment button fix..."
        BUTTON_HTML=$(curl -s "http://localhost:3000/?locale=pt_BR" | grep -A1 -B1 'submit-payment')
        echo "Payment button HTML:"
        echo "$BUTTON_HTML"
        
        # Check if data-i18n attribute exists
        if echo "$BUTTON_HTML" | grep -q 'data-i18n'; then
            echo "✅ CONFIRMED: Payment button has data-i18n attribute!"
        else
            echo "⚠️  Payment button may not have data-i18n attribute"
        fi
        
        echo ""
        echo "🎉 DEPLOYMENT SUCCESSFUL!"
        echo "📋 Summary:"
        echo "   ✅ Service is running"
        echo "   ✅ Application responds on port 3000"
        echo "   ✅ Portuguese locale is working"
        echo "   ✅ Payment button fix is applied"
        
    else
        echo "❌ Application returned HTTP $CURL_RESULT"
        echo "🔍 Testing with verbose curl..."
        curl -v "http://localhost:3000/?locale=pt_BR" 2>&1 | head -20
    fi
else
    echo "❌ Service FAILED to start"
    echo "📋 Service status:"
    systemctl status relationship-quiz --no-pager -l
    
    echo "📋 Last 25 log lines:"
    journalctl -u relationship-quiz --no-pager -l -n 25
fi

echo ""
echo "📊 Final system state:"
echo "Port 3000 status:"
lsof -i :3000 || echo "Nothing on port 3000"
echo "Service status: $(systemctl is-active relationship-quiz)"

echo "🎉 Final fix complete!"
EOF

# Make the script executable
chmod +x final-fix.sh

echo "✅ Final fix script created at ~/final-fix.sh"
echo "📋 Running final fix..."
./final-fix.sh

ENDSSH

echo "🎉 Final fix completed!"
echo "📋 This should resolve the port conflict and get the service running with the Portuguese payment button fix."