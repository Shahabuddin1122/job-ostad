const { pool } = require('../config/db');

const Question = {
    async createMultiple(quiz_id, questions) {
        const client = await pool.connect();
        try {
            await client.query('BEGIN');

            const examScriptResult = await client.query(
                `INSERT INTO exam_script (quiz_id) VALUES ($1) RETURNING id;`,
                [quiz_id]
            );
            const exam_script_id = examScriptResult.rows[0].id;

            for (const question of questions) {
                const { question: q, answer, options, image, subject } = question;

                // Convert options array into PostgreSQL array format
                const optionsFormatted = `{${options.map(opt => `"${opt}"`).join(',')}}`;

                await client.query(
                    `INSERT INTO question (exam_script_id, question, answer, options, image, subject)
                     VALUES ($1, $2, $3, $4, $5, $6);`,
                    [exam_script_id, q, answer, optionsFormatted, image, subject]
                );
            }

            await client.query('COMMIT');
            return { success: true };
        } catch (error) {
            await client.query('ROLLBACK');
            console.error('Error creating questions:', error);
            throw error;
        } finally {
            client.release();
        }
    },

    async getAllQuestionOfAQuiz(quizId) {
        const query = `
            SELECT q.title, q.number_of_questions, q.total_time, qs.question, qs.options, qs.image, qs.subject
            FROM quiz q 
            INNER JOIN exam_script es ON q.id = es.quiz_id
            INNER JOIN question qs ON es.id = qs.exam_script_id
            WHERE q.id = $1
        `;
        const values = [quizId];
        const results = await pool.query(query, values);
        return results.rows;
    }
};

module.exports = Question;
