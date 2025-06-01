const express = require('express')
const {get_question, create_question, update_or_add_questions} = require("../controllers/exam.controller");
const multer = require('multer');

const router = express.Router()
const upload = multer({ storage: multer.memoryStorage() });

router.get("/get-question-by-quiz-id/:quizId", get_question)
router.post("/create-question", upload.array('images'), create_question)
router.put('/update-question', upload.array('images'), update_or_add_questions);

module.exports = router;