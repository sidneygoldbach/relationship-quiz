#!/bin/bash

# EXECUTE THIS SCRIPT DIRECTLY ON THE KAMATERA SERVER
# Payment Button Portuguese Fix for Kamatera Production

echo "🚀 Applying payment button Portuguese fix..."

# Navigate to app directory
cd /root/relationship-quiz

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
        echo "🔗 Test at: http://185.224.138.75:3000/?locale=pt_BR"
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