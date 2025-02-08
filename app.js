// app.js
const express = require('express');
const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

// Define a basic route for testing
app.get('/', (req, res) => {
    res.send('Hello from your backend!');
});

// Example endpoint: Get posts (for now, just returns a static message)
app.get('/posts', (req, res) => {
    res.json({ message: 'Here you will get posts' });
});

// Example endpoint: Create a new post
app.post('/posts', (req, res) => {
    const { userId, content } = req.body;
    if (!userId || !content) {
        return res.status(400).json({ error: 'userId and content are required' });
    }
    // In a real app, you'd save this data to your database (or Firebase Firestore)
    const newPost = {
        id: Date.now(), // Temporary ID using timestamp
        userId,
        content,
        createdAt: new Date(),
    };
    res.status(201).json(newPost);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

// app.js (partial update)
const firebase = require('./firebaseConfig');
const firestore = firebase.firestore();

// Replace the POST /posts route to save data in Firestore
app.post('/posts', async (req, res) => {
    const { userId, content } = req.body;
    if (!userId || !content) {
        return res.status(400).json({ error: 'userId and content are required' });
    }

    try {
        const postData = {
            userId,
            content,
            createdAt: firebase.firestore.FieldValue.serverTimestamp(),
        };
        const docRef = await firestore.collection('posts').add(postData);
        res.status(201).json({ id: docRef.id, ...postData });
    } catch (error) {
        res.status(500).json({ error: 'Error creating post', details: error });
    }
});