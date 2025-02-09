const express = require("express");
const cors = require("cors");
const connectDB = require("./database/connect");
const tripRoutes = require("./routes/trips");

const app = express();
app.use(express.json());
app.use(cors());

connectDB();  // Connect to MongoDB

app.get("/", (req, res) => {
    console.log("[GET] Request received at /");
    res.send("Welcome to the Road Trip Backend with MongoDB!");
});

app.use((req, res, next) => {
    console.log(`[${req.method}] ${req.originalUrl} - Body:`, req.body);
    next();
});

app.use("/trip", tripRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});
