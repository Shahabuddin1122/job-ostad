const {pool} = require('../config/db')

const User = {
    async create({username, email, phone_number, education, password}){
        const query = `
            INSERT INTO users(username, email, phone_number, education, password)
            values($1, $2, $3, $4, $5)
            RETURNING *
        `;
        const values = [username, email, phone_number, education, password]

        const results = await pool.query(query, values)
        return results.rows[0];
    },

    async getAll(){
        const query = `
            SELECT * FROM users
        `;
        const results =  await pool.query(query)
        return results.rows;
    },

    async findOne(field, value) {
        const allowedFields = ['id', 'username', 'email', 'phone_number'];
        if (!allowedFields.includes(field)) {
            throw new Error('Invalid field for lookup');
        }

        const query = `
      SELECT * FROM users WHERE ${field} = $1 LIMIT 1
    `;
        const values = [value];
        const results = await pool.query(query, values);
        return results.rows[0];
    },

    async findUserStat(id){
        const query = `
            SELECT u.username, u.email, ARRAY_AGG(DATE(r.submission_time) ORDER BY r.submission_time DESC) AS submission_times 
            FROM users u 
            INNER JOIN results r ON u.id = r.user_id 
            WHERE u.id = $1 
            GROUP BY u.id 
            LIMIT 1
        `;
        const values = [id];
        const results = await pool.query(query, values);
        return results.rows[0];
    }
};

module.exports = User;