const express = require("express");
const app = express();
const PORT = 3000;

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello, Express!");
});

app.get("/greet/:name", (req, res) => {
  res.send(`Hello, ${req.params.name}!`);
});

app.post("/data", (req, res) => {
  console.log(req.body);
  res.json({ message: "Data received", data: req.body });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
