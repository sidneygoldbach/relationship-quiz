// Facebook SDK Integration

// Initialize the Facebook SDK
function initFacebookSDK() {
    // Check if we're running on HTTPS
    const isSecure = window.location.protocol === 'https:';
    
    if (!isSecure) {
        console.warn('Facebook SDK requires HTTPS. Skipping Facebook integration in development.');
        return;
    }
    
    window.fbAsyncInit = function() {
        FB.init({
            appId: 'YOUR_FACEBOOK_APP_ID', // Replace with your Facebook App ID
            cookie: true,
            xfbml: true,
            version: 'v17.0' // Use the latest version available
        });
        
        FB.AppEvents.logPageView();
        
        // Check login status
        checkLoginStatus();
    };
    
    // Load the Facebook SDK asynchronously
    (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "https://connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
}

// Check if the user is logged in to Facebook
function checkLoginStatus() {
    // Check if we're running on HTTPS or localhost
    const isSecure = window.location.protocol === 'https:' || window.location.hostname === 'localhost';
    
    if (!isSecure) {
        console.warn('Facebook login requires HTTPS. Skipping login check in development.');
        return;
    }
    
    try {
        FB.getLoginStatus(function(response) {
            if (response.status === 'connected') {
                // User is logged in to Facebook and has authorized the app
                console.log('Logged in and authenticated');
                getUserInfo();
            } else {
                // User is either not logged in or has not authorized the app
                console.log('Not authenticated');
            }
        });
    } catch (error) {
        console.warn('Facebook SDK error:', error.message);
        console.log('Facebook features disabled in development environment.');
    }
}

// Get user information from Facebook
function getUserInfo() {
    FB.api('/me', {fields: 'name,email'}, function(response) {
        if (response && !response.error) {
            console.log('User info:', response);
            // You can use the user's name and email here
            // For example, display a personalized welcome message
            if (document.getElementById('welcome-screen')) {
                const welcomeMessage = document.querySelector('#welcome-screen p');
                if (welcomeMessage) {
                    welcomeMessage.textContent = `Hello ${response.name}! Discover insights about your relationship style and get personalized advice!`;
                }
            }
        }
    });
}

// Facebook login function
function facebookLogin() {
    // Check if we're running on HTTPS
    const isSecure = window.location.protocol === 'https:';
    
    if (!isSecure) {
        alert('Facebook login requires HTTPS. This feature is only available in production.');
        return;
    }
    
    try {
        FB.login(function(response) {
            if (response.authResponse) {
                console.log('Welcome! Fetching your information...');
                getUserInfo();
            } else {
                console.log('User cancelled login or did not fully authorize.');
            }
        }, {scope: 'email'});
    } catch (error) {
        console.error('Facebook login error:', error.message);
        alert('Facebook login is not available in development environment.');
    }
}

// Share quiz results on Facebook
function shareResults() {
    // Check if we're running on HTTPS
    const isSecure = window.location.protocol === 'https:';
    
    if (!isSecure) {
        // Fallback for development - copy link to clipboard
        const personalityType = document.getElementById('personality-result').textContent;
        const shareText = `I just took the Relationship Quiz and discovered I'm ${personalityType}. Take the quiz to find out your relationship personality! ${window.location.href}`;
        
        if (navigator.clipboard) {
            navigator.clipboard.writeText(shareText).then(() => {
                alert('Quiz result copied to clipboard! You can paste it on Facebook.');
            }).catch(() => {
                alert('Facebook sharing requires HTTPS. This feature is only available in production.');
            });
        } else {
            alert('Facebook sharing requires HTTPS. This feature is only available in production.');
        }
        return;
    }
    
    try {
        // Get the personality type from the results screen
        const personalityType = document.getElementById('personality-result').textContent;
        
        FB.ui({
            method: 'share',
            href: window.location.href,
            quote: `I just took the Relationship Quiz and discovered I'm ${personalityType}. Take the quiz to find out your relationship personality!`
        }, function(response) {
            if (response && !response.error_message) {
                console.log('Success posting');
            } else {
                console.log('Error while posting');
            }
        });
    } catch (error) {
        console.error('Facebook sharing error:', error.message);
        alert('Facebook sharing is not available in development environment.');
    }
}

// Add a share button to the results screen
function addShareButton() {
    const resultsScreen = document.getElementById('results-screen');
    if (resultsScreen) {
        const shareButton = document.createElement('button');
        shareButton.id = 'share-btn';
        shareButton.className = 'btn';
        shareButton.style.backgroundColor = '#4267B2'; // Facebook blue
        shareButton.textContent = 'Share on Facebook';
        shareButton.addEventListener('click', shareResults);
        
        // Insert before the restart button
        const restartBtn = document.getElementById('restart-btn');
        if (restartBtn) {
            resultsScreen.insertBefore(shareButton, restartBtn);
        } else {
            resultsScreen.appendChild(shareButton);
        }
    }
}

// Initialize when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initFacebookSDK();
    
    // Add the share button when results are displayed
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.target.id === 'results-screen' && 
                mutation.target.classList.contains('active')) {
                addShareButton();
            }
        });
    });
    
    const resultsScreen = document.getElementById('results-screen');
    if (resultsScreen) {
        observer.observe(resultsScreen, {
            attributes: true,
            attributeFilter: ['class']
        });
    }
});