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

exports.getCourseByCourseId = async (req, res)=>{
  try {
    const {courseId} = req.params;
    const response = await Course.getById(courseId);
    res.status(200).json({ success: true, message: response });
  }
  catch (e) {
    res.status(500).json({ message: "Server error", error: e.message })
  }
}

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
    const data = await Course.getAllCollection()
    res.json({
      success: true,
      data: data
    });
  }
  catch (error) {
    res.status(500).json({"message": "Server error", error: error.message});
  }
}

exports.getTopCourses = async (req, res) =>{
  try {
    const results = await Course.findFavouriteCourse();
    res.status(200).json({status: true, message: results})
  }
  catch (e) {
    res.status(500).json({status: false, message: `Server error ${e.message}`})
  }
}

exports.deleteCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const deletedCourse = await Course.delete(id);

    if (!deletedCourse) {
      return res.status(404).json({ success: false, message: "Course not found" });
    }

    res.status(200).json({
      success: true,
      message: "Course deleted successfully",
      data: deletedCourse,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: "Server error", error: error.message });
  }
};

exports.updateCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, category, keywords } = req.body;

    let course_image = null;
    if (req.files && req.files["course_image"]) {
      const uploaded = await imgbb(req.files["course_image"][0]);
      course_image = uploaded.url;
    }

    // Build an update object with only the provided fields
    const updateData = {};
    if (title) updateData.title = title;
    if (description) updateData.description = description;
    if (category) updateData.category = category;
    if (keywords) updateData.keywords = keywords;
    if (course_image) updateData.course_image = course_image;

    // If no fields are being updated
    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({ message: "No fields provided to update." });
    }

    const updatedCourse = await Course.update(id, updateData);

    if (!updatedCourse) {
      return res.status(404).json({ success: false, message: "Course not found" });
    }

    res.status(200).json({ success: true, message: "Course updated successfully", data: updatedCourse });
  } catch (error) {
    res.status(500).json({ success: false, message: "Server error", error: error.message });
  }
};

