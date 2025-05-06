const axios = require("axios");
require("dotenv").config();

exports.send_sms = async (toNumber, message) => {
    try {
        await axios.post(`https://api.sms.net.bd/sendsms?api_key=${process.env.PORTAL_SMS_KEY}&msg=${encodeURIComponent(message)}&to=${toNumber}`);
        return true;
    } catch (error) {
        return false;
    }
};
