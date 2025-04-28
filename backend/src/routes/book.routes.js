const express = require("express");
const multer = require("multer");
const {
    bookTest,
    getAllBooks,
    addBook,
} = require("../controllers/book.controller");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

/**
 * @swagger
 * tags:
 *   name: Books
 *   description: Book management endpoints
 */

/**
 * @swagger
 * /book:
 *   get:
 *     summary: Test book route
 *     tags: [Books]
 *     responses:
 *       200:
 *         description: Returns a test message
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Book route working!
 */
router.get("/", bookTest);

/**
 * @swagger
 * /book/get-all-books:
 *   get:
 *     summary: Get all books
 *     tags: [Books]
 *     responses:
 *       200:
 *         description: List of all books
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
 *                     $ref: '#/components/schemas/Book'
 *       500:
 *         description: Server error
 */
router.get("/get-all-books", getAllBooks);

/**
 * @swagger
 * /book/add-book:
 *   post:
 *     summary: Add a new book
 *     tags: [Books]
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
 *                 example: "Sample Book Title"
 *               author:
 *                 type: string
 *                 example: "John Doe"
 *               description:
 *                 type: string
 *                 example: "This is a sample book description"
 *               book_image:
 *                 type: string
 *                 format: binary
 *               book_pdf:
 *                 type: string
 *                 format: binary
 *     responses:
 *       201:
 *         description: Book created successfully
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
 *                   example: "Book added successfully"
 *                 data:
 *                   $ref: '#/components/schemas/Book'
 *       400:
 *         description: Invalid input
 *       500:
 *         description: Server error
 */
router.post(
    "/add-book",
    upload.fields([
        { name: "book_image", maxCount: 1 },
        { name: "book_pdf", maxCount: 1 },
    ]),
    addBook
);

/**
 * @swagger
 * components:
 *   schemas:
 *     Book:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           example: "507f1f77bcf86cd799439011"
 *         title:
 *           type: string
 *           example: "Sample Book"
 *         author:
 *           type: string
 *           example: "John Doe"
 *         description:
 *           type: string
 *           example: "This is a sample book description"
 *         imageUrl:
 *           type: string
 *           example: "http://example.com/book.jpg"
 *         pdfUrl:
 *           type: string
 *           example: "http://example.com/book.pdf"
 *         createdAt:
 *           type: string
 *           format: date-time
 *           example: "2023-05-01T12:00:00Z"
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           example: "2023-05-01T12:00:00Z"
 */

module.exports = router;