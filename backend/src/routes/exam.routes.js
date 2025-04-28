const express = require('express')
const {get_question, create_question} = require("../controllers/exam.controller");

const router = express.Router()

router.get("/get-question-by-quiz-id/:quizId", get_question)
router.post("/create-question", create_question)

module.exports = router;