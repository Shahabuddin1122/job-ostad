const fs = require("fs");
const express = require("express");
const multer = require("multer");
const path = require("path");
const imgbbUploader = require("imgbb-uploader");
const dotenv = require("dotenv");
const { google } = require("googleapis");
const stream = require("stream");
const Book = require("../models/book.model");

const router = express.Router();
dotenv.config();

const upload = multer({ storage: multer.memoryStorage() });

const auth = new google.auth.GoogleAuth({
  keyFile: process.env.GOOGLE_DRIVE_KEYFILE,
  scopes: ["https://www.googleapis.com/auth/drive.file"],
});

const drive = google.drive({ version: "v3", auth });

async function uploadToDrive(file, folderId) {
  const bufferStream = new stream.PassThrough();
  bufferStream.end(file.buffer);

  const response = await drive.files.create({
    requestBody: {
      name: file.originalname,
      mimeType: file.mimetype,
      parents: [folderId],
    },
    media: {
      mimeType: file.mimetype,
      body: bufferStream,
    },
  });

  await drive.permissions.create({
    fileId: response.data.id,
    requestBody: {
      role: "reader",
      type: "anyone",
    },
  });

  return `https://drive.google.com/uc?id=${response.data.id}`;
}

router.get("/", (req, res) => {
  res.json({ success: true, message: "Book API works fine" });
});

router.post(
  "/add-book",
  upload.fields([
    { name: "book_image", maxCount: 1 },
    { name: "book_pdf", maxCount: 1 },
  ]),
  async (req, res) => {
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

      // Upload image to ImgBB
      const imgbbResponse = await imgbbUploader({
        apiKey: process.env.IMGBB_API_KEY,
        base64string: book_image.buffer.toString("base64"),
      });
      book_image = imgbbResponse.url;

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
  }
);

router.get("/get-all-books", async (req, res) => {
  const allBook = await Book.getAll();
  res.status(200).json({
    message: "All Book fetched successfully",
    data: allBook,
  });
});

module.exports = router;
