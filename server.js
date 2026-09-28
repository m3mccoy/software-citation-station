const express = require("express");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

// 1. Serve static files (CSS, JS, Images) directly from the root directory
app.use(express.static(path.join(__dirname)));

// 2. Handle the root route to explicitly send index.html
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

// 3. Start the server
app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
