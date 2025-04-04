const express = require("express");
const { course, addCourse } = require("../controllers/course.controller");

const app = express.Router();

app.get("/", course);
app.post("/add-course", addCourse);

module.exports = app;
