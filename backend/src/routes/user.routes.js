const express = require('express')
const {add_user_question_response, get_user_results, get_exam_script_by_result_id} = require("../controllers/user.controller");
const {authenticateToken} = require("../middlewares/auth.middleware");

const router = express.Router()

router.post('/add-user-question-response', authenticateToken, add_user_question_response)
router.get('/get-user-result', authenticateToken, get_user_results)
router.get('/get-exam-script', get_exam_script_by_result_id)

module.exports = router;