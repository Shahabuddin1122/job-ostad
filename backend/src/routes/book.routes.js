const express = require("express");
const multer = require("multer");
const {
  bookTest,
  getAllBooks,
  addBook,
} = require("../controllers/book.controller");

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.get("/", bookTest);
router.post(
  "/add-book",
  upload.fields([
    { name: "book_image", maxCount: 1 },
    { name: "book_pdf", maxCount: 1 },
  ]),
  addBook
);
router.get("/get-all-books", getAllBooks);

module.exports = router;
