#!/bin/bash

# Create the payment fix script in home directory on Kamatera server
# This solves directory access issues

echo "🚀 Creating payment fix script in home directory on Kamatera server..."

# Server details
SERVER_IP="194.113.194.224"
SERVER_USER="root"

echo "📝 Creating script in home directory..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd ~

# Create the payment fix script in home directory
cat > kamatera-payment-fix.sh << 'EOF'
#!/bin/bash

# EXECUTE THIS SCRIPT DIRECTLY ON THE KAMATERA SERVER
# Payment Button Portuguese Fix for Kamatera Production

echo "🚀 Applying payment button Portuguese fix..."

# Navigate to app directory
cd /var/www/relationship-quiz

# Check if directory exists
if [ ! -d "/var/www/relationship-quiz" ]; then
    echo "❌ Directory /var/www/relationship-quiz not found!"
    echo "📋 Checking common locations..."
    
    # Check other possible locations
    if [ -d "/home/relationship-quiz" ]; then
        echo "✅ Found app at /home/relationship-quiz"
        cd /home/relationship-quiz
    elif [ -d "/opt/relationship-quiz" ]; then
        echo "✅ Found app at /opt/relationship-quiz"
        cd /opt/relationship-quiz
    elif [ -d "/root/relationship-quiz" ]; then
        echo "✅ Found app at /root/relationship-quiz"
        cd /root/relationship-quiz
    else
        echo "❌ Cannot find relationship-quiz directory!"
        echo "📋 Please check where the app is installed:"
        find / -name "index.html" -path "*/relationship-quiz/*" 2>/dev/null | head -5
        exit 1
    fi
fi

echo "📍 Working in directory: $(pwd)"

# Check if index.html exists
if [ ! -f "index.html" ]; then
    echo "❌ index.html not found in $(pwd)!"
    echo "📋 Files in current directory:"
    ls -la
    exit 1
fi

# Backup current index.html
echo "📋 Creating backup..."
cp index.html index.html.backup.$(date +%Y%m%d_%H%M%S)

# Apply the fix to index.html
echo "🔧 Fixing payment button..."

# Fix 1: Add data-i18n attribute to payment button
sed -i 's/<button id="submit-payment" class="btn"><\/button>/<button id="submit-payment" class="btn" data-i18n="payment.button_pay">Pay Now<\/button>/' index.html

# Fix 2: Update JavaScript for better translation handling
sed -i 's/submitButton.textContent = `${window.i18n.t("payment.payButton")} ${currencyInfo.symbol}${currencyInfo.amount.toFixed(2)}`;/const buttonText = window.i18n.t("payment.button_pay") || window.i18n.t("payment.payButton") || "Pay";\n                     submitButton.textContent = `${buttonText} ${currencyInfo.symbol}${currencyInfo.amount.toFixed(2)}`;\n                     console.log("Payment button updated:", submitButton.textContent);/' index.html

echo "✅ Fixes applied to index.html"

# Restart the service
echo "🔄 Restarting relationship-quiz service..."
systemctl restart relationship-quiz

# Wait for service to start
sleep 3

# Check service status
if systemctl is-active --quiet relationship-quiz; then
    echo "✅ Service restarted successfully"
    
    # Test the application
    echo "🧪 Testing application..."
    curl -s "http://localhost:3000/?locale=pt_BR" > /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Application is responding"
        echo "🌐 Portuguese payment button fix is now live!"
        echo "🔗 Test at: http://194.113.194.224:3000/?locale=pt_BR"
    else
        echo "❌ Application test failed"
    fi
else
    echo "❌ Service failed to restart"
    echo "📋 Service status:"
    systemctl status relationship-quiz
    
    echo "🔄 Attempting to restore backup..."
    cp index.html.backup.* index.html 2>/dev/null || echo "No backup found"
fi

echo "🎉 Payment button Portuguese fix deployment complete!"
EOF

# Make the script executable
chmod +x kamatera-payment-fix.sh

echo "✅ Script created successfully at ~/kamatera-payment-fix.sh"
echo "📋 You can now run: ./kamatera-payment-fix.sh"
echo "📍 Current directory: $(pwd)"
echo "📋 Files in home directory:"
ls -la ~/kamatera-payment-fix.sh

ENDSSH

echo "🎉 Script created in home directory on Kamatera server!"
echo "📋 Next steps:"
echo "   1. SSH to server: ssh root@194.113.194.224"
echo "   2. Run the script: ./kamatera-payment-fix.sh"
echo "   3. The script will automatically find the correct app directory"