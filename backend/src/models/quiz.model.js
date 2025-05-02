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
        WHERE q.course_id = $1
        ORDER BY q.date DESC
        `;

        const value = [id];
        const results = await pool.query(query, value);
        return results.rows;
    }


}

module.exports = Quiz