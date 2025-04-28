const Question = require('../models/question.model');

// Create multiple questions (NO exam_script_id given)
exports.create_question = async (req, res) => {
    try {
        const { quiz_id, questions } = req.body;

        if (!quiz_id || !Array.isArray(questions) || questions.length === 0) {
            return res.status(400).json({ success: false, message: "quiz_id and non-empty questions array are required." });
        }

        const newQuestions = await Question.createMultiple(quiz_id, questions);

        res.status(201).json({ success: true, data: newQuestions });
    } catch (error) {
        console.error('Error creating questions:', error);
        res.status(500).json({ success: false, message: 'Internal server error.' });
    }
};

// Get all questions for a quiz
exports.get_question = async (req, res) => {
    try {
        const { quizId } = req.params;

        if (!quizId) {
            return res.status(400).json({ success: false, message: "quizId is required." });
        }

        const questions = await Question.getAllQuestionOfAQuiz(quizId);

        res.status(200).json({ success: true, data: questions });
    } catch (error) {
        console.error('Error fetching questions:', error);
        res.status(500).json({ success: false, message: 'Internal server error.' });
    }
};
