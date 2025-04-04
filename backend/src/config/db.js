const { Pool } = require("pg");
const logger = require("./logger");
require("dotenv").config();

const pool = new Pool({
  connectionString: process.env.PG_URI, // Example: "postgres://user:password@localhost:5432/mydb"
});

const connectDB = async () => {
  try {
    await pool.connect();
    logger.info("PostgreSQL Connected");
  } catch (error) {
    logger.error("Database connection error:", error);
    process.exit(1);
  }
};

module.exports = { connectDB, pool };
