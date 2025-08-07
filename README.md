# Relationship Quiz Facebook App

A Facebook quiz application that asks users 5 questions about their relationship style, provides personalized results and advice after payment processing through Stripe.

## Features

- Interactive 5-question relationship quiz
- Personality type determination based on answers
- Stripe payment integration ($1 USD)
- Personalized results with:
  - Personality type description
  - 5 personality insights
  - 5 relationship improvement tips
- Responsive design for all devices
- Facebook integration ready

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Stripe account for payment processing

## Installation

1. Clone the repository or download the files

2. Install dependencies:
   ```
   npm install
   ```

3. Stripe Configuration:
   - The application is already configured with live Stripe keys
   - Note: If you're testing the application, you should use real payment information as the app is set up with live keys

## Running the Application

1. Start the server:
   ```
   npm start
   ```

2. Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

## Facebook Integration

To deploy this quiz as a Facebook app:

1. Create a Facebook Developer account and register a new app
2. Set up Facebook Login and configure the OAuth redirect URI
3. Deploy this application to a hosting service (e.g., Heroku, Vercel, AWS)
4. Configure the Facebook app settings to point to your deployed application
5. Add the Facebook SDK to the application (follow Facebook's documentation)

## Customization

- Modify the questions in `quiz.js` to change the quiz content
- Adjust the personality types and advice in `quiz.js`
- Update the styling in `styles.css` to match your branding
- Change the payment amount in `server.js` (amount is in cents, e.g., 100 = $1.00)

## Payment Information

The application is configured with live Stripe keys:
- You will need to use a real payment card to complete the quiz
- The charge amount is $1.00 USD
- Your payment information is securely processed by Stripe

## License

MIT