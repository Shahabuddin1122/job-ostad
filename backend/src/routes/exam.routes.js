const express = require('express')
const {get_question} = require("../controllers/exam.controller");

const router = express.Router()

router.get("/get-question", get_question)

module.exports = router;