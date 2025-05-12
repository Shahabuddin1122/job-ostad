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

exports.get_user_results = async (req, res) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            return res.status(401).json({ status: false, message: "Unauthorized" });
        }

        const token = authHeader.split(" ")[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user_id = decoded.userId;

        const results = await Results.getByUserId({ user_id });

        // Convert string values to numbers and calculate totals
        let total_correct = 0;
        let total_wrong = 0;

        for (let result of results) {
            result.number_of_correct = parseInt(result.number_of_correct);
            result.number_of_wrong = parseInt(result.number_of_questions) - parseInt(result.number_of_correct);
            total_correct += result.number_of_correct;
            total_wrong += result.number_of_wrong;
        }

        res.status(200).json({
            status: true,
            data: {
                total_exams: results.length,
                total_correct,
                total_wrong,
                results
            }
        });
    } catch (e) {
        res.status(500).json({ status: false, message: `Serve error: ${e.message}` });
    }
};
