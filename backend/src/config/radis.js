const { createClient } = require("redis");
const logger = require("./logger");
require('dotenv').config();

const redisClient = createClient({
    url: process.env.REDIS_URL,
});

redisClient.on('error', (err) => logger.error('Redis Client Error', err));

async function connectRedis() {
    try {
        await redisClient.connect();
        logger.info("Redis client connected successfully");
    } catch (err) {
        logger.error("Failed to start redis server:", err);
        process.exit(1);
    }
}

module.exports = { connectRedis, redisClient };
