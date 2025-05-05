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
        return results.rows[0]; // returns undefined if not found
    }
};

module.exports = User;