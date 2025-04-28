require("dotenv").config();

module.exports = {
    direction: 'up',
    migrationsTable: 'pgmigrations',
    dir: 'migrations',
    databaseUrl: process.env.PG_URI,
};
