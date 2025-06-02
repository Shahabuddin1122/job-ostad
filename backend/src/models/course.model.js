const {pool} = require('../config/db')


const Course = {
    async create({title, description, category, keywords, course_image}){
        const query = `
          INSERT INTO courses (title, description, category, keywords, course_image)
          VALUES ($1, $2, $3, $4, $5)
          RETURNING *;
        `;
        const values = [
            title,
            description,
            category,
            keywords,
            course_image
        ];
        const result = await pool.query(query, values);
        return result.rows[0];
    },

    async getAll() {
        const result = await pool.query(
            "SELECT * FROM courses ORDER BY created_at DESC;"
        );
        return result.rows;
    },

    async getById(courseId){
        const query = `SELECT * FROM courses WHERE id=$1`;
        const values = [courseId]

        const result = await pool.query(query, values);
        return result.rows[0];
    },

    async getCourseByCategory(category) {
        const query = `
          SELECT * FROM courses
          WHERE lower(category) = lower($1)
          ORDER BY created_at DESC;
        `;
        const values = [category];
        const result = await pool.query(query, values);
        return result.rows;
    },

    async getAllCollection(){
        const query = `
            SELECT title, category, id FROM courses
        `;

        const results = await pool.query(query);
        return results.rows;
    },

    async findFavouriteCourse() {
        const query = `
        WITH popular_courses AS (
            SELECT
                c.id,
                c.title,
                c.description,
                c.category,
                c.keywords,
                c.course_image,
                c.created_at,
                COUNT(DISTINCT r.user_id) as user_count
            FROM results r
            INNER JOIN exam_script es ON r.exam_script_id = es.id
            INNER JOIN quiz q ON es.quiz_id = q.id
            INNER JOIN courses c ON q.course_id = c.id
            GROUP BY c.id, c.title, c.description, c.category, c.keywords, c.course_image, c.created_at
        ),
        ranked_courses AS (
            SELECT
                id,
                title,
                description,
                category,
                keywords,
                course_image,
                created_at,
                user_count,
                ROW_NUMBER() OVER (ORDER BY user_count DESC) as rn
            FROM popular_courses
        ),
        top_courses AS (
            SELECT
                id,
                title,
                description,
                category,
                keywords,
                course_image,
                created_at
            FROM ranked_courses
            WHERE rn <= 2
        ),
        fallback_courses AS (
            SELECT
                id,
                title,
                description,
                category,
                keywords,
                course_image,
                created_at
            FROM courses
            WHERE id NOT IN (SELECT id FROM top_courses)
            ORDER BY RANDOM()
            LIMIT GREATEST(0, 2 - (SELECT COUNT(*) FROM top_courses))
        )
        SELECT id, title, description, category, keywords, course_image, created_at
        FROM (
            SELECT id, title, description, category, keywords, course_image, created_at
            FROM top_courses
            UNION
            SELECT id, title, description, category, keywords, course_image, created_at
            FROM fallback_courses
        ) AS combined
        ORDER BY (
            SELECT COUNT(DISTINCT r.user_id)
            FROM results r
            JOIN exam_script es ON r.exam_script_id = es.id
            JOIN quiz q ON es.quiz_id = q.id
            WHERE q.course_id = combined.id
        ) DESC NULLS LAST;
    `;

        const results = await pool.query(query);
        return results.rows; // Return all rows, not just the first one
    },

    async delete(id) {
        const result = await pool.query("DELETE FROM courses WHERE id = $1 RETURNING *;", [id]);
        return result.rows[0];
    },

    async update(id, fields) {
      const keys = Object.keys(fields).filter(key => fields[key] !== undefined);
      if (keys.length === 0) return null;

      const setClause = keys.map((key, idx) => `${key} = $${idx + 1}`).join(', ');
      const values = keys.map(key => fields[key]);

      const query = `
        UPDATE courses SET ${setClause}
        WHERE id = $${keys.length + 1}
        RETURNING *;
      `;

      const result = await pool.query(query, [...values, id]);
      return result.rows[0];
    }


};

module.exports = Course