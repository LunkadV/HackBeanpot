// app.js

// Import required modules
const express = require("express");
const cors = require("cors");

// Create an instance of Express
const app = express();

// Middleware to parse incoming JSON requests
app.use(express.json());
// Middleware to enable Cross-Origin Resource Sharing (CORS)
app.use(cors());

// A simple GET route to verify the server is running
app.get("/", (req, res) => {
    res.send("Welcome to the Road Trip Backend!");
});

// POST route for building a road trip
app.post("/roadtrip", (req, res) => {
    // Extract the start and end locations from the request body
    const { start, end } = req.body;

    // If either start or end is missing, return a 400 error
    if (!start || !end) {
        return res.status(400).json({ error: "Start and end locations are required." });
    }

    // Create a dummy road trip response
    const roadTrip = {
        start: start,
        end: end,
        route: `Your road trip from ${start} to ${end} is ready! (This is a dummy route.)`
    };

    // Return the dummy road trip as JSON
    return res.json(roadTrip);
});

// Set the port to the environment variable PORT, or default to 3000
const PORT = process.env.PORT || 3000;

// Start the server and log a message to the console
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});