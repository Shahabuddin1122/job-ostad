const express = require('express')
const {get_question, create_question} = require("../controllers/exam.controller");
const multer = require('multer');

const router = express.Router()
const upload = multer({ storage: multer.memoryStorage() });

router.get("/get-question-by-quiz-id/:quizId", get_question)
router.post("/create-question", upload.array('images'), create_question)

module.exports = router;