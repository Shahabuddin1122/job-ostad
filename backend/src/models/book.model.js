const { pool } = require("../config/db");

const Book = {
  async create({
    title,
    description,
    writer,
    visibility,
    book_image,
    book_pdf,
  }) {
    const query = `
          INSERT INTO books (title, description, writer, visibility, book_image, book_pdf)
          VALUES ($1, $2, $3, $4, $5, $6)
          RETURNING *;
        `;
    const values = [
      title,
      description,
      writer,
      visibility,
      book_image,
      book_pdf,
    ];
    console.log(title, description, writer, visibility, book_image, book_pdf)
    const result = await pool.query(query, values);
    return result.rows[0];
  },

  async getAll() {
    const result = await pool.query(
      "SELECT * FROM books ORDER BY created_at DESC;"
    );
    return result.rows;
  },
};

module.exports = Book;
