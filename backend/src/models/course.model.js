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
};

module.exports = Course