const Quiz = require("../models/quiz.model");
const Course = require("../models/course.model");

exports.get_all_quiz = async (req, res)=>{
    try {
        const getAll = await Quiz.findAll()

        res.json({message: "All the quiz successfully", data: getAll})
    }
    catch (error) {
        res.status(500).json({"message": "Server error", error: error.message});
    }
}

exports.add_a_quiz = async (req, res)=>{
    try {
        const {title, description, date, visibility, number_of_questions, total_time, keywords, course_id} = req.body;

        if(!title || !description || !date || !visibility || !number_of_questions || !total_time || !keywords || !course_id) {
            return res.status(400).json({ message: "All fields are required" });
        }

        const newQuiz = await Quiz.create({title, description, date, visibility, number_of_questions, total_time, keywords, course_id})

        res.json({
            message: "Quiz created successfully",
            data: newQuiz
        });
    }
    catch (error) {
        res.status(500).json({message: "Server error", error: error.message});
    }
}

exports.get_quiz_by_category = async (req, res)=>{
    try {
        const { category } = req.query
        console.log(category)

        const quizItem = await Quiz.findByCategory(category)
        res.json({
            message: "Quiz created successfully",
            data: quizItem
        });
    }
    catch (error) {
        res.status(500).json({"message": "Server error", error: error.message});
    }
}

exports.getAllQuizByCourseId = async (req, res)=>{
    try {
        const {courseId} = req.params;

        const data = await Quiz.getAllQuizByCourseID(courseId)

        res.status(200).json({success: true, message: data})
    }
    catch (error) {
        res.status(500).json({success: false, message: `Server Error: ${error.message}`});
    }
}