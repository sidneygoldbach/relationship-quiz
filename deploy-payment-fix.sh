#!/bin/bash

# Deploy Payment Button Portuguese Fix to Kamatera
# This script applies the payment button translation fix to the production server

echo "🚀 Deploying payment button Portuguese fix to Kamatera..."

# Server details
SERVER_IP="185.224.138.75"
SERVER_USER="root"
APP_DIR="/root/relationship-quiz"

# Create temporary fix file
cat > payment_button_fix.patch << 'EOF'
--- a/index.html
+++ b/index.html
@@ -44,5 +44,5 @@
                  <form id="payment-form">
                      <div id="payment-element"></div>
-                     <button id="submit-payment" class="btn"></button>
+                     <button id="submit-payment" class="btn" data-i18n="payment.button_pay">Pay Now</button>
                      <div id="payment-message"></div>
                  </form>
@@ -81,5 +81,7 @@
                  if (submitButton && window.i18n && window.i18n.initialized) {
                      const currencyInfo = window.i18n.getCurrencyInfo();
-                     submitButton.textContent = `${window.i18n.t('payment.payButton')} ${currencyInfo.symbol}${currencyInfo.amount.toFixed(2)}`;
+                     const buttonText = window.i18n.t('payment.button_pay') || window.i18n.t('payment.payButton') || 'Pay';
+                     submitButton.textContent = `${buttonText} ${currencyInfo.symbol}${currencyInfo.amount.toFixed(2)}`;
+                     console.log('Payment button updated:', submitButton.textContent);
                  }
              }, 100);
EOF

echo "📁 Uploading fix to server..."
scp payment_button_fix.patch $SERVER_USER@$SERVER_IP:/tmp/

echo "🔧 Applying fix on server..."
ssh $SERVER_USER@$SERVER_IP << 'ENDSSH'
cd /root/relationship-quiz

# Backup current index.html
cp index.html index.html.backup.$(date +%Y%m%d_%H%M%S)

# Apply the patch
echo "Applying payment button fix..."
patch -p1 < /tmp/payment_button_fix.patch

if [ $? -eq 0 ]; then
    echo "✅ Patch applied successfully"
    
    # Restart the service
    echo "🔄 Restarting relationship-quiz service..."
    systemctl restart relationship-quiz
    
    # Wait a moment for service to start
    sleep 3
    
    # Check service status
    if systemctl is-active --quiet relationship-quiz; then
        echo "✅ Service restarted successfully"
        echo "🌐 Testing Portuguese payment button..."
        
        # Test the fix
        curl -s "http://localhost:3000/?locale=pt_BR" > /dev/null
        if [ $? -eq 0 ]; then
            echo "✅ Portuguese locale is working"
        else
            echo "❌ Error testing Portuguese locale"
        fi
    else
        echo "❌ Service failed to restart"
        systemctl status relationship-quiz
    fi
else
    echo "❌ Failed to apply patch"
    exit 1
fi

# Cleanup
rm /tmp/payment_button_fix.patch
ENDSSH

# Cleanup local files
rm payment_button_fix.patch

echo "🎉 Payment button Portuguese fix deployed successfully!"
echo "🔗 Test at: http://185.224.138.75:3000/?locale=pt_BR"