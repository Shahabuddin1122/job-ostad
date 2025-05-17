const dotenv = require("dotenv");
const Book = require("../models/book.model");
const { imgbb } = require("../services/imagebb.service");
const { uploadToDrive } = require("../services/googledrive.service");
const jwt = require("jsonwebtoken");

dotenv.config();

exports.bookTest = (req, res) => {
  res.json({ success: true, message: "Book API works fine" });
};

exports.getAllBooks = async (req, res) => {
  const allBook = await Book.getAll();
  res.status(200).json({
    message: "All Book fetched successfully",
    data: allBook,
  });
};

exports.addBook = async (req, res) => {
  try {
    const { title, description, writer, visibility } = req.body;
    let book_image = req.files["book_image"]
      ? req.files["book_image"][0]
      : null;
    let book_pdf = req.files["book_pdf"] ? req.files["book_pdf"][0] : null;

    if (
      !title ||
      !description ||
      !writer ||
      !visibility ||
      !book_image ||
      !book_pdf
    ) {
      return res.status(400).json({ message: "All fields are required" });
    }
    book_image = await imgbb(book_image);
    book_image = book_image.url;

    // Upload PDF to Google Drive
    const folderId = process.env.GOOGLE_DRIVE_FOLDER_ID;
    book_pdf = await uploadToDrive(book_pdf, folderId);

    const newBook = await Book.create({
      title,
      description,
      writer,
      visibility,
      book_image: book_image,
      book_pdf: book_pdf,
    });

    res.status(201).json({
      message: "Book added successfully",
      data: newBook,
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.updateTheBookStudyCount = async (req, res)=>{
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ status: false, message: "Unauthorized" });
    }

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user_id = decoded.userId;
    const {book_id} = req.body;
    console.log(book_id)

    await Book.updateTheBookStudyCount({user_id, book_id})

    res.status(200).json({status: true, message: "Data updated Successfully"})
  }
  catch (e) {
    res.status(500).json({status: false, message: `Server error: ${e.message}`})
  }
}

exports.getTopStudiedBook = async (req, res) => {
  try {
    const results = await Book.getTopStudiedBook()
    res.status(200).json({status: true, message: results})
  }
  catch (e) {
    res.status(500).json({status: false, message: `Server error: ${e.message}`})
  }
}