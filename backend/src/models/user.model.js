const {pool} = require('../config/db')
const bcrypt = require("bcryptjs");

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
            LEFT JOIN results r ON u.id = r.user_id 
            WHERE u.id = $1 
            GROUP BY u.id 
            LIMIT 1
        `;
        const values = [id];
        const results = await pool.query(query, values);
        return results.rows[0];
    },

    async updateById(id, fields) {
    const allowedFields = ['username', 'email', 'education'];
    const keys = Object.keys(fields).filter(key => allowedFields.includes(key));

    if (keys.length === 0) {
      throw new Error('No valid fields to update');
    }

    // Build SET clause dynamically: field1 = $1, field2 = $2 ...
    const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(', ');
    const values = keys.map(key => fields[key]);

    const query = `
      UPDATE users
      SET ${setClause}
      WHERE id = $${keys.length + 1}
      RETURNING *;
    `;

    values.push(id); // Add user ID at the end

    const result = await pool.query(query, values);
    return result.rows[0];
  },

  async updatePasswordById(id, currentPassword, newPassword) {
    const userQuery = `SELECT password FROM users WHERE id = $1 LIMIT 1`;
    const userResult = await pool.query(userQuery, [id]);

    if (userResult.rowCount === 0) {
      throw new Error("User not found");
    }

    const storedHash = userResult.rows[0].password;
    const match = await bcrypt.compare(currentPassword, storedHash);
    if (!match) {
      throw new Error("Incorrect current password");
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    const updateQuery = `
      UPDATE users
      SET password = $1
      WHERE id = $2
      RETURNING id, username, email;
    `;
    const updateResult = await pool.query(updateQuery, [hashedPassword, id]);
    return updateResult.rows[0];
  }

};

module.exports = User;