const mongoose = require("mongoose");

const TripSchema = new mongoose.Schema({
    destination: { type: String, required: true, index: true },
    startDate: { type: Date, required: true, index: true },
    endDate: { type: Date, required: true },
    tripType: { type: String, enum: ["Beach", "Mountain", "City", "Nature"], required: true },
    createdAt: { type: Date, default: Date.now, index: true },
});

TripSchema.index({ destination: 1, startDate: 1 }); // Optimize queries for trip searches

module.exports = mongoose.model("Trip", TripSchema);
