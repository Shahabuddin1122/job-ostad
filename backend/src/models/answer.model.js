const { pool } = require('../config/db');

const Answer = {
    async create({ question_id, result_id, is_correct, selected_option }) {
        const query = `
      INSERT INTO answer_script (question_id, result_id, is_correct, selected_option) 
      VALUES ($1, $2, $3, $4) 
      RETURNING *;
    `;
        const values = [question_id, result_id, is_correct, selected_option];
        const response = await pool.query(query, values);
        return response.rows[0];
    },

    async getAll() {
        const query = `SELECT * FROM answer_script ORDER BY id DESC;`;
        const response = await pool.query(query);
        return response.rows;
    },

    async getById(id) {
        const query = `SELECT * FROM answer_script WHERE id = $1;`;
        const response = await pool.query(query, [id]);
        return response.rows[0];
    },
};

module.exports = Answer;
