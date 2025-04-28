const { imgbb } = require("../services/imagebb.service");
const Course = require("../models/course.model");

exports.getAllCourse = async (req, res) => {
  try {
    const all_books = await Course.getAll();
    res.status(200).json({ success: true, message: all_books });
  }
  catch (error) {
    res.status(500).json({message: "Server error", error: error.message })
  }
};

exports.addCourse = async (req, res) => {
  try {
    const {title, description, category, keywords} =  req.body
    let course_image = req.files && req.files["course_image"] ? req.files["course_image"][0] : null;

    if(!title || !description || !category || !keywords || !course_image){
      return res.status(400).json({ message: "All fields are required" });
    }
    course_image = await imgbb(course_image)
    course_image = course_image.url

    const newCourse = await Course.create({
      title,description,category,keywords,course_image
    })

    res.status(201).json({
      message: "Course Create Successfully",
      data: newCourse
    })

  }
  catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getCoursesOnEachCategory = async (req, res)=>{
  try {
    const { category } = req.query;
    const getCourses = await Course.getCourseByCategory(category)
    res.status(200).json({ success: true, message: getCourses });
  }
  catch (e) {
    res.status(500).json({ message: "Server error", error: e.message })
  }
};

exports.getAllCollection = async (req, res)=>{
  try {
    res.json({
      message: "Quiz created successfully",
      data: "newQuiz"
    });
  }
  catch (error) {
    res.status(500).json({"message": "Server error", error: error.message});
  }
}