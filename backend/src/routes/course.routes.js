const express = require("express");
const { getAllCourse, addCourse, getCoursesOnEachCategory} = require("../controllers/course.controller");
const multer = require("multer");

const app = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

app.get("/get-all-course", getAllCourse);
app.post("/add-course", upload.fields([{name:"course_image", maxCount: 1}]) ,addCourse);
app.get("/get-category-courses", getCoursesOnEachCategory);

module.exports = app;
