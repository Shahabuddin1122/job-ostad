const {pool} = require('../config/db')

const Quiz = {
    async create({title, description, date, visibility, number_of_questions, total_time, keywords, course_id}){
        const query=`
            INSERT INTO quiz(title, description, date, visibility, number_of_questions, total_time, keywords, course_id) 
            values ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING *;
        `;
        const values = [
            title,
            description,
            date,
            visibility,
            number_of_questions,
            total_time,
            keywords,
            course_id
        ];
        const results = await pool.query(query, values)
        return results.rows[0]
    },

    async findAll(){
        const query = `
            SELECT * FROM quiz ORDER BY created_at DESC
        `;

        const results = await pool.query(query)
        return results.rows;
    },
    async findByCategory(category){
        const query = `
            SELECT * FROM quiz 
            WHERE lower(collection) = lower($1)
            ORDER BY created_at DESC;
        `;
        const values = [category]
        const results = await pool.query(query, values)
        return results.rows;
    },

    async findById(id){
        const query = `
            SELECT * FROM quiz 
            WHERE id = $1;
        `;
        const values = [id]
        const results = await pool.query(query, values)
        return results.rows[0];
    },

    async getAllQuizByCourseID(id) {
        const query = `
        SELECT  
            q.id AS quiz_id, 
            q.title, 
            q.description, 
            q.number_of_questions, 
            q.total_time,
            q.date,
            CASE 
                WHEN es.id IS NULL THEN false 
                ELSE true 
            END AS has_exam_script
        FROM quiz q 
        LEFT JOIN exam_script es ON q.id = es.quiz_id
        WHERE q.course_id = $1 AND q.date >= CURRENT_DATE
        ORDER BY q.date ASC
        `;

        const value = [id];
        const results = await pool.query(query, value);
        return results.rows;
    },

    async getUnansweredQuizByCourseID(courseId, userId) {
        const query = `
            SELECT
                q.id AS quiz_id,
                q.title,
                q.description,
                q.number_of_questions,
                q.total_time,
                q.date,
                CASE
                    WHEN es.id IS NULL THEN false
                    ELSE true
                    END AS has_exam_script
            FROM quiz q
                     LEFT JOIN exam_script es ON q.id = es.quiz_id
                     LEFT JOIN results rs ON rs.exam_script_id = es.id AND rs.user_id = $2
            WHERE q.course_id = $1
              AND rs.id IS NULL
              AND q.date >= CURRENT_DATE
            ORDER BY q.date ASC
        `;

        const value = [courseId, userId];
        const results = await pool.query(query, value);
        return results.rows;
    },

    async delete(id) {
        const query = `
            DELETE FROM quiz
            WHERE id = $1
            RETURNING *;
        `;
        const result = await pool.query(query, [id]);
        return result.rows[0]; // Return the deleted quiz (or null if not found)
    },

    async update(id, data) {
        const keys = Object.keys(data);
        if (keys.length === 0) return null;

        const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(', ');
        const values = Object.values(data);

        const query = `
            UPDATE quiz
            SET ${setClause}
            WHERE id = $${keys.length + 1}
            RETURNING *;
        `;

        const result = await pool.query(query, [...values, id]);
        return result.rows[0];
    }

}

module.exports = Quiz