const dotenv = require("dotenv");
const Book = require("../models/book.model");
const { imgbb } = require("../services/imagebb.service");
const { uploadToDrive } = require("../services/googledrive.service");

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
