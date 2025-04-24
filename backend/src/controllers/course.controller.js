const { imgbb } = require("../services/imagebb.service");
const Course = require("../models/course.model");

exports.course = (req, res) => {
  res.status(200).json({ success: true, message: "Course api works fine" });
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
    console.log(course_image)

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
