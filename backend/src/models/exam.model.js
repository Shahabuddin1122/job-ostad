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
            SELECT es.id AS exam_script_id, q.title, q.number_of_questions, q.total_time, qs.question, qs.options, qs.image, qs.subject, qs.id AS question_id
            FROM quiz q 
            INNER JOIN exam_script es ON q.id = es.quiz_id
            INNER JOIN question qs ON es.id = qs.exam_script_id
            WHERE q.id = $1
        `;
        const values = [quizId];
        const results = await pool.query(query, values);
        return results.rows;
    },

    async findByPk(id){
        const query = `
            SELECT * FROM question 
            WHERE id = $1
        `;
        const values = [id];
        const results = await pool.query(query, values)
        return results.rows[0];
    },

    async updateQuestion(question) {
        const { id, question: q, answer, options, image, subject } = question;
        const optionsFormatted = `{${options.map(opt => `"${opt}"`).join(',')}}`;

        let query, values;

        if (image) {
            query = `
                UPDATE question 
                SET question = $1, answer = $2, options = $3, image = $4, subject = $5
                WHERE id = $6
            `;
            values = [q, answer, optionsFormatted, image, subject, id];
        } else {
            query = `
                UPDATE question 
                SET question = $1, answer = $2, options = $3, subject = $4
                WHERE id = $5
            `;
            values = [q, answer, optionsFormatted, subject, id];
        }
        await pool.query(query, values);
    },

    async addSingleQuestion(exam_script_id, question) {
        const { question: q, answer, options, image, subject } = question;
        const optionsFormatted = `{${options.map(opt => `"${opt}"`).join(',')}}`;

        const query = `
            INSERT INTO question (exam_script_id, question, answer, options, image, subject)
            VALUES ($1, $2, $3, $4, $5, $6)
        `;
        const values = [exam_script_id, q, answer, optionsFormatted, image, subject];
        await pool.query(query, values);
    },

    async getExamScriptIdByQuizId(quiz_id) {
        const result = await pool.query(`SELECT id FROM exam_script WHERE quiz_id = $1 LIMIT 1`, [quiz_id]);
        return result.rows[0]?.id;
    }
};

module.exports = Question;
