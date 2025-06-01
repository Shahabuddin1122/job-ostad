const express = require('express')
const {add_user_question_response, get_user_results, get_exam_script_by_result_id, get_user_info, get_user_stat,
    update_user_info
} = require("../controllers/user.controller");
const {authenticateToken} = require("../middlewares/auth.middleware");

const router = express.Router()

router.post('/add-user-question-response', authenticateToken, add_user_question_response)
router.get('/get-user-result', authenticateToken, get_user_results)
router.get('/get-exam-script', authenticateToken, get_exam_script_by_result_id)
router.get('/get-user-details', authenticateToken, get_user_info)
router.get('/get-user-stat', authenticateToken, get_user_stat)
router.put('/update-user-info', authenticateToken, update_user_info)

module.exports = router;