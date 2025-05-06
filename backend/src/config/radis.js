const { createClient } = require("redis");
const logger = require("./logger");
require('dotenv').config()

const redisClient = createClient({
    url: `redis://${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`
});

redisClient.on("error", (err) => console.error("Redis Client Error", err));

(async () => {
    try {
        await redisClient.connect();
        logger.data("Redis Database Connected")
    }
    catch (e) {
        logger.error("Error to connect on Redis");    }
})();

module.exports = redisClient;
