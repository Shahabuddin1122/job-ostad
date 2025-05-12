const { pool } = require('../config/db');

const Results = {
    // Create a new result entry
    async create({ score, exam_script_id, user_id }) {
        const query = `
      INSERT INTO results (score, exam_script_id, user_id)
      VALUES ($1, $2, $3)
      RETURNING *;
    `;
        const values = [score, exam_script_id, user_id];
        const response = await pool.query(query, values);
        return response.rows[0];
    },

    // Get all results
    async getAll() {
        const query = `SELECT * FROM results ORDER BY id DESC;`;
        const response = await pool.query(query);
        return response.rows;
    },

    // Get result by ID
    async getById(id) {
        const query = `SELECT * FROM results WHERE id = $1;`;
        const response = await pool.query(query, [id]);
        return response.rows[0];
    },

    // Get results by user ID
    async getByUserId({ user_id }) {
        const query = `
        SELECT 
            r.id AS result_id,
            q.title,
            r.score,
            q.number_of_questions,
            COUNT(a.*) FILTER (WHERE a.is_correct = true) AS number_of_correct
        
        FROM results r
        INNER JOIN exam_script es ON r.exam_script_id = es.id
        INNER JOIN quiz q ON q.id = es.quiz_id
        LEFT JOIN answer_script a ON a.result_id = r.id
        WHERE r.user_id = $1
        GROUP BY r.id, q.id, q.title, r.score, q.number_of_questions
        ORDER BY q.id DESC;
    `;

        const response = await pool.query(query, [user_id]);
        return response.rows;
    },


    async update({score, id}){
        const updateQuery = `
            UPDATE results SET score = $1 WHERE id = $2 RETURNING *;
        `;
        const values = [score, id]
        const updateResult = await pool.query(updateQuery, values);
        return updateResult.rows[0]
    }
};

module.exports = Results;
