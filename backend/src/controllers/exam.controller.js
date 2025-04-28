const Question = require('../models/exam.model');
const { imgbb } = require("../services/imagebb.service");

exports.create_question = async (req, res) => {
    try {
        const { quiz_id } = req.body;
        let questions = JSON.parse(req.body.questions);

        if (req.files && req.files.length > 0) {
            const imageFiles = req.files;

            for (let i = 0; i < questions.length; i++) {
                if (imageFiles[i]) {
                    const uploadedImage = await imgbb(imageFiles[i]);
                    questions[i].image = uploadedImage.url; // replace image field with imgbb URL
                }
            }
        }

        await Question.createMultiple(quiz_id, questions);
        res.status(201).json({ success: true, message: "Questions created successfully" });
    } catch (error) {
        console.error('Error creating questions:', error);
        res.status(500).json({ success: false, message: 'Failed to create questions' });
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
