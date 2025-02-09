const express = require("express");
const cors = require("cors");
const connectDB = require("./database/connect");

const app = express();
app.use(express.json());
app.use(cors());

connectDB();  // Connect to MongoDB

app.get("/", (req, res) => {
    res.send("Welcome to the Road Trip Backend with MongoDB!");
});

const tripRoutes = require("./routes/trips");
app.use("/trip", tripRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});