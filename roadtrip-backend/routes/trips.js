const express = require("express");
const Trip = require("../models/Trip");

const router = express.Router();

// Create a new trip
router.post("/", async (req, res) => {
    try {
        const { destination, startDate, endDate, tripType } = req.body;
        if (!destination || !startDate || !endDate || !tripType) {
            return res.status(400).json({ error: "All fields are required." });
        }
        const newTrip = new Trip({ destination, startDate, endDate, tripType });
        await newTrip.save();
        res.status(201).json(newTrip);
    } catch (error) {
        res.status(500).json({ error: "Error creating trip" });
    }
});

// Get trip details
router.get("/:id", async (req, res) => {
    try {
        const trip = await Trip.findById(req.params.id);
        if (!trip) {
            return res.status(404).json({ error: "Trip not found" });
        }
        res.json(trip);
    } catch (error) {
        res.status(500).json({ error: "Error retrieving trip" });
    }
});

// Delete a trip
router.delete("/:id", async (req, res) => {
    try {
        const deletedTrip = await Trip.findByIdAndDelete(req.params.id);
        if (!deletedTrip) {
            return res.status(404).json({ error: "Trip not found" });
        }
        res.json({ message: "Trip deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: "Error deleting trip" });
    }
});

module.exports = router;