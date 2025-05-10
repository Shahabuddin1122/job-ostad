const { createClient } = require("redis");
const logger = require("./logger");
require('dotenv').config()

const redisClient = createClient({url: process.env.REDIS_URL})
    .on('error', (err)=> logger.error('Redis Client Error', err))
    .connect();

async function connectRedis() {
    try {
        await redisClient;
        logger.info("Redis client connected successfully");
    } catch (err) {
        logger.error("Failed to start redis server:", err);
        process.exit(1); // Exit with failure
    }
}

module.exports = {connectRedis};
