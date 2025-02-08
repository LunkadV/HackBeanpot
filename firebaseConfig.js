// firebaseConfig.js
const firebase = require('firebase/app');
require('firebase/auth');
require('firebase/firestore');

// Replace the following config object with your Firebase project's configuration
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
    // Add other configuration options as needed
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Export Firebase so you can use it elsewhere in your project
module.exports = firebase;