// app.js
const express = require('express');
const app = express();

// Middleware to parse JSON request bodies
app.use(express.json());

// Sample in-memory posts array (this simulates a database for now)
let posts = [
    { id: 1, userId: 'user1', content: 'Hello, world!', createdAt: new Date() },
    { id: 2, userId: 'user2', content: 'Welcome to the app!', createdAt: new Date() }
];

// GET endpoint to fetch posts (e.g., for your home page feed)
app.get('/posts', (req, res) => {
    res.json(posts);
});

// Optionally, add an endpoint to create a new post
app.post('/posts', (req, res) => {
    const { userId, content } = req.body;
    if (!userId || !content) {
        return res.status(400).json({ error: 'userId and content are required' });
    }
    const newPost = {
        id: posts.length + 1, // simple incremental id
        userId,
        content,
        createdAt: new Date(),
    };
    posts.push(newPost);
    res.status(201).json(newPost);
});

// Start the server on port 3000 (or another port if set)
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});