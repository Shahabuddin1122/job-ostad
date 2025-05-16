const express = require("express");
const { getAllCourse, addCourse, getCoursesOnEachCategory, getAllCollection, getAllQuizByCourseId, getTopCourses} = require("../controllers/course.controller");
const multer = require("multer");
const {route} = require("express/lib/application");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

/**
 * @swagger
 * tags:
 *   name: Courses
 *   description: Course management endpoints
 */

/**
 * @swagger
 * /course/get-all-course:
 *   get:
 *     summary: Get all courses
 *     tags: [Courses]
 *     responses:
 *       200:
 *         description: List of all courses
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Course'
 *       500:
 *         description: Server error
 */
router.get("/get-all-course", getAllCourse);

/**
 * @swagger
 * /course/add-course:
 *   post:
 *     summary: Add a new course
 *     tags: [Courses]
 *     consumes:
 *       - multipart/form-data
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 example: "Introduction to Programming"
 *               description:
 *                 type: string
 *                 example: "Learn programming fundamentals"
 *               category:
 *                 type: string
 *                 example: "Programming"
 *               price:
 *                 type: number
 *                 example: 49.99
 *               duration:
 *                 type: string
 *                 example: "8 weeks"
 *               course_image:
 *                 type: string
 *                 format: binary
 *     responses:
 *       201:
 *         description: Course created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Course added successfully"
 *                 data:
 *                   $ref: '#/components/schemas/Course'
 *       400:
 *         description: Invalid input
 *       500:
 *         description: Server error
 */
router.post("/add-course", upload.fields([{name:"course_image", maxCount: 1}]), addCourse);

/**
 * @swagger
 * /course/get-courses-by-category:
 *   get:
 *     summary: Get courses by category
 *     tags: [Courses]
 *     parameters:
 *       - in: query
 *         name: category
 *         schema:
 *           type: string
 *         required: true
 *         description: Category name to filter courses
 *     responses:
 *       200:
 *         description: List of courses in the specified category
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Course'
 *       404:
 *         description: No courses found for this category
 *       500:
 *         description: Server error
 */
router.get("/get-courses-by-category", getCoursesOnEachCategory);

/**
 * @swagger
 * /course/get-all-collection:
 *   get:
 *     summary: Get all unique course collections
 *     tags: [Courses]
 *     responses:
 *       200:
 *         description: List of all available course collections
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: string
 *                     example: "47th BCS"
 *       500:
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: false
 *                 message:
 *                   type: string
 *                   example: "Error fetching collections"
 */
router.get('/get-all-collection', getAllCollection)

/**
 * @swagger
 * components:
 *   schemas:
 *     Course:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           example: "507f1f77bcf86cd799439011"
 *         title:
 *           type: string
 *           example: "Introduction to Programming"
 *         description:
 *           type: string
 *           example: "Learn programming fundamentals"
 *         category:
 *           type: string
 *           example: "Programming"
 *         price:
 *           type: number
 *           example: 49.99
 *         duration:
 *           type: string
 *           example: "8 weeks"
 *         imageUrl:
 *           type: string
 *           example: "http://example.com/course.jpg"
 *         createdAt:
 *           type: string
 *           format: date-time
 *           example: "2023-05-01T12:00:00Z"
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           example: "2023-05-01T12:00:00Z"
 */

router.get('/get-top-courses', getTopCourses)

module.exports = router;