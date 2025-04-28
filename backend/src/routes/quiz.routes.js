const express = require('express')
const {add_a_quiz, get_all_quiz, get_quiz_by_category} = require("../controllers/quiz.controller");

const router = express.Router()

router.get("/get-all-quiz", get_all_quiz)
router.post("/add-a-quiz", add_a_quiz)
router.get("/get-quiz", get_quiz_by_category)

module.exports = router