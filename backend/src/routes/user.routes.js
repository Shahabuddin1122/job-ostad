const express = require('express')
const {add_user_question_response} = require("../controllers/user.controller");
const {authenticateToken} = require("../middlewares/auth.middleware");

const router = express.Router()

router.post('/add-user-question-response', authenticateToken, add_user_question_response)

module.exports = router;