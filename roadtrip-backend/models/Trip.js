const mongoose = require("mongoose");

const TripSchema = new mongoose.Schema({
    id: { type: String, required: true, unique: true },
    tripName: { type: String, required: true },
    date: { type: String, required: true },
    distance: { type: String, required: true },
    stops: { type: String, required: true },
    heroTag: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Trip", TripSchema);