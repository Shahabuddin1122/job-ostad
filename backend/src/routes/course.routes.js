const express = require("express");
const { getAllCourse, addCourse } = require("../controllers/course.controller");
const multer = require("multer");

const app = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

app.get("/get-all-course", getAllCourse);
app.post("/add-course", upload.fields([{name:"course_image", maxCount: 1}]) ,addCourse);

module.exports = app;
