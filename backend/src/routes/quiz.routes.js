const express = require('express')
const {add_a_quiz, get_all_quiz} = require("../controllers/quiz.controller");

const router = express.Router()

router.get("/get-all-quiz", get_all_quiz)
router.post("/add-a-quiz", add_a_quiz)

module.exports = router