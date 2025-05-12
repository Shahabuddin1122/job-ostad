const express = require('express')
const {add_user_question_response, get_user_results} = require("../controllers/user.controller");
const {authenticateToken} = require("../middlewares/auth.middleware");

const router = express.Router()

router.post('/add-user-question-response', authenticateToken, add_user_question_response)
router.get('/get-user-result', authenticateToken, get_user_results)

module.exports = router;