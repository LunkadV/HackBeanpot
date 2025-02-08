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