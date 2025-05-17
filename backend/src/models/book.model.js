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
  },

  async updateTheBookStudyCount({ user_id, book_id }) {
    const client = await pool.connect();

    try {
      await client.query('BEGIN');

      const res = await client.query(
          `SELECT study_count FROM studies WHERE user_id = $1 AND book_id = $2`,
          [user_id, book_id]
      );

      if (res.rows.length > 0) {
        await client.query(
            `UPDATE studies
         SET study_count = study_count + 1
         WHERE user_id = $1 AND book_id = $2`,
            [user_id, book_id]
        );
      } else {
        await client.query(
            `INSERT INTO studies (user_id, book_id, study_count)
         VALUES ($1, $2, 1)`,
            [user_id, book_id]
        );
      }

      await client.query('COMMIT');
    } catch (err) {
      await client.query('ROLLBACK');
    } finally {
      client.release();
    }
  }
};

module.exports = Book;
