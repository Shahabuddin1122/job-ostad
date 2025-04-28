const {pool} = require('../config/db')

const Quiz = {
    async create({title, description, collection, visibility, number_of_questions, total_time, keywords}){
        const query=`
            INSERT INTO quiz(title, description, collection, visibility, number_of_questions, total_time, keywords) 
            values ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *;
        `;
        const values = [
            title,
            description,
            collection,
            visibility,
            number_of_questions,
            total_time,
            keywords
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
}

module.exports = Quiz