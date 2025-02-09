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

// POST route for building a road trip with multiple stops
app.post("/roadtrip", (req, res) => {
    // Extract start, end, and waypoints from the request body
    const { start, end, waypoints } = req.body;

    // Validate inputs
    if (!start || !end) {
        return res.status(400).json({ error: "Start and end locations are required." });
    }
    if (waypoints && !Array.isArray(waypoints)) {
        return res.status(400).json({ error: "Waypoints must be an array." });
    }

    // Construct a dummy road trip response
    let routeDescription = `Your road trip starts at ${start} and ends at ${end}.`;
    if (waypoints && waypoints.length > 0) {
        routeDescription += " Stops include: " + waypoints.join(", ") + ".";
    }

    const roadTrip = {
        start: start,
        end: end,
        waypoints: waypoints || [],
        route: routeDescription
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