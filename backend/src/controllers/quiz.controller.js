const Quiz = require("../models/quiz.model");
const Course = require("../models/course.model");
const jwt = require("jsonwebtoken");

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
            message: "Successfully Fetched",
            data: quizItem
        });
    }
    catch (error) {
        res.status(500).json({"message": "Server error", error: error.message});
    }
}

exports.get_quiz_by_id = async (req, res)=>{
    try {
        const { quizId } = req.params

        const quizItem = await Quiz.findById(quizId)
        res.json({
            message: "Successfully fetched",
            data: quizItem
        });
    }
    catch (error) {
        res.status(500).json({"message": "Server error", error: error.message});
    }
}

exports.getAllQuizByCourseId = async (req, res) => {
    try {
        const { courseId } = req.params;
        const authHeader = req.headers.authorization;
        let userId = null;

        if (authHeader) {
            const token = authHeader.split(" ")[1];
            try {
                const decoded = jwt.verify(token, process.env.JWT_SECRET);
                userId = decoded.userId;
            } catch (err) {
                console.warn("Invalid or expired token, fetching all quizzes.");
            }
        }

        let data;
        if (userId) {
            data = await Quiz.getUnansweredQuizByCourseID(courseId, userId);
        } else {
            data = await Quiz.getAllQuizByCourseID(courseId);
        }

        res.status(200).json({ success: true, message: data });
    } catch (error) {
        res.status(500).json({ success: false, message: `Server Error: ${error.message}` });
    }
};

exports.update_quiz_by_id = async (req, res) => {
    try {
        const { id } = req.params;
        const updatedData = req.body;

        if (Object.keys(updatedData).length === 0) {
            return res.status(400).json({ message: "No data provided to update" });
        }

        const updatedQuiz = await Quiz.update(id, updatedData);

        if (!updatedQuiz) {
            return res.status(404).json({ message: "Quiz not found or no changes applied" });
        }

        res.json({ message: "Quiz updated successfully", data: updatedQuiz });
    } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

exports.delete_quiz_by_id = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedQuiz = await Quiz.delete(id);

        if (!deletedQuiz) {
            return res.status(404).json({ message: "Quiz not found" });
        }

        res.json({ message: "Quiz deleted successfully", data: deletedQuiz });
    } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
    }
};
