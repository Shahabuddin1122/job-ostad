const jwt = require("jsonwebtoken");
const User = require("../models/user.model");
const Results = require("../models/result.model");
const Answer = require("../models/answer.model");
const Question = require("../models/exam.model");

require('dotenv').config()

exports.add_user_question_response = async (req, res) => {
    try {
        const authHeader = req.headers.authorization;
        const { exam_script_id, answers } = req.body;
        if (!authHeader) {
            return res.status(401).json({ status: false, message: "Unauthorized" });
        }

        const token = authHeader.split(" ")[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user_id = decoded.userId;

        // Create result with initial score of 0
        const result = await Results.create({ score: 0, exam_script_id, user_id });

        let totalCorrect = 0;

        for (const answer of answers) {
            const question = await Question.findByPk(answer.question_id);
            if (!question) {
                return res.status(404).json({ status: false, message: `Question ${answer.question_id} not found` });
            }

            const is_correct = question["answer"] === answer.selected_option;
            if (is_correct) totalCorrect++;

            await Answer.create({
                question_id: answer.question_id,
                result_id: result.id,
                selected_option: answer.selected_option,
                is_correct: is_correct
            });
        }

        const userResults = await Results.update({score: totalCorrect, id: result.id})

        res.json({ status: true, message: userResults });
    } catch (e) {
        res.status(500).json({ status: false, message: `Server error: ${e.message}` });
    }
};
