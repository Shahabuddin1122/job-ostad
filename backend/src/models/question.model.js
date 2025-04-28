const { pool } = require('../config/db');

const Question = {
    async create({ exam_script_id, question, answer, options, image, subject }) {
        const query = `
            INSERT INTO question (exam_script_id, question, answer, options, image, subject)
            VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING *;
        `;
        const values = [exam_script_id, question, answer, options, image, subject];
        const results = await pool.query(query, values);
        return results.rows[0];
    },

    async getAllQuestionOfAQuiz(quizId) {
        const query = `
            SELECT q.*
            FROM question q
            INNER JOIN exam_script es ON q.exam_script_id = es.id
            WHERE es.quiz_id = $1
            ORDER BY q.id ASC;
        `;
        const values = [quizId];
        const results = await pool.query(query, values);
        return results.rows;
    }
};

module.exports = Question;
