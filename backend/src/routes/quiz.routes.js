const express = require('express')
const { add_a_quiz, get_all_quiz, get_quiz_by_category, getAllQuizByCourseId, delete_quiz_by_id, update_quiz_by_id} = require("../controllers/quiz.controller");

const router = express.Router()

/**
 * @swagger
 * tags:
 *   name: Quizzes
 *   description: Quiz management endpoints
 */

/**
 * @swagger
 * /quiz/get-all-quiz:
 *   get:
 *     summary: Get all quizzes
 *     tags: [Quizzes]
 *     responses:
 *       200:
 *         description: List of all quizzes
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Quiz'
 *       500:
 *         description: Server error
 */
router.get("/get-all-quiz", get_all_quiz)

/**
 * @swagger
 * /quiz/add-a-quiz:
 *   post:
 *     summary: Add a new quiz
 *     tags: [Quizzes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/QuizInput'
 *     responses:
 *       201:
 *         description: Quiz created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Quiz'
 *       400:
 *         description: Invalid input
 *       500:
 *         description: Server error
 */
router.post("/add-a-quiz", add_a_quiz)

/**
 * @swagger
 * /quiz/get-quiz:
 *   get:
 *     summary: Get quizzes by category
 *     tags: [Quizzes]
 *     parameters:
 *       - in: query
 *         name: collection
 *         schema:
 *           type: string
 *         required: true
 *         description: Collection name to filter quizzes
 *       - in: query
 *         name: visibility
 *         schema:
 *           type: string
 *           enum: [Admin, Public]
 *         description: Visibility level to filter quizzes
 *     responses:
 *       200:
 *         description: List of quizzes matching the criteria
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Quiz'
 *       404:
 *         description: No quizzes found
 *       500:
 *         description: Server error
 */
router.get("/get-quiz", get_quiz_by_category)

router.get('/get-all-quiz-by-courseId/:courseId', getAllQuizByCourseId);

/**
 * @swagger
 * /quiz/get-all-quiz-by-courseId/:courseId:
 *  get:
 *    summary: Get all unique course collections
 *    tags: [Courses]
 *    parameters:
 *      - in: params
 *        name: courseId
 *        schema:
 *          type: string
 *        required: true
 *        description: course id to get the quiz
 *    responses:
 *      200:
 *          description: list of all quiz
 *      500:
 *          description: server error
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     Quiz:
 *       type: object
 *       properties:
 *         id:
 *           type: integer
 *           example: 1
 *         title:
 *           type: string
 *           example: "A"
 *         description:
 *           type: string
 *           example: "B"
 *         collection:
 *           type: string
 *           example: "47th BCS"
 *         visibility:
 *           type: string
 *           enum: [Admin, Public]
 *           example: "Admin"
 *         number_of_questions:
 *           type: integer
 *           example: 20
 *         total_time:
 *           type: integer
 *           example: 10
 *         keywords:
 *           type: string
 *           example: "BCS"
 *         created_at:
 *           type: string
 *           format: date-time
 *           example: "2025-04-28T15:32:32.062Z"
 *     QuizInput:
 *       type: object
 *       required:
 *         - title
 *         - collection
 *         - number_of_questions
 *         - total_time
 *       properties:
 *         title:
 *           type: string
 *           example: "A"
 *         description:
 *           type: string
 *           example: "B"
 *         collection:
 *           type: string
 *           example: "47th BCS"
 *         visibility:
 *           type: string
 *           enum: [Admin, Public]
 *           example: "Admin"
 *         number_of_questions:
 *           type: integer
 *           example: 20
 *         total_time:
 *           type: integer
 *           example: 10
 *         keywords:
 *           type: string
 *           example: "BCS"
 */

router.delete('/delete-quiz/:id', delete_quiz_by_id)
router.put('/update-quiz/:id', update_quiz_by_id)

module.exports = router