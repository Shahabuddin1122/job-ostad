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

  async getTopStudiedBook() {
    const query = `
        WITH TopStudied AS (
            SELECT b.id, b.title, b.description, b.writer, b.visibility, b.book_image, b.book_pdf, b.created_at,
                   COALESCE(SUM(s.study_count), 0) as total_study_count
            FROM books b
            LEFT JOIN studies s ON b.id = s.book_id
            GROUP BY b.id, b.title, b.description, b.writer, b.visibility, b.book_image, b.book_pdf, b.created_at
            ORDER BY total_study_count DESC
            LIMIT 1
        ),
        OtherBooks AS (
            SELECT id, title, description, writer, visibility, book_image, book_pdf, created_at
            FROM books
            WHERE id NOT IN (SELECT id FROM TopStudied)
            ORDER BY RANDOM()
            LIMIT 1
        )
        SELECT id, title, description, writer, visibility, book_image, book_pdf, created_at
        FROM TopStudied
        UNION ALL
        SELECT id, title, description, writer, visibility, book_image, book_pdf, created_at
        FROM OtherBooks;
    `;

    const results = await pool.query(query);
    return results.rows;
  }
};

module.exports = Book;
