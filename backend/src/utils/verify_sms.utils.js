const {redisClient} = require("../config/radis");

const OTP_EXPIRY_SECONDS = 5 * 60; // 5 minutes

exports.saveOtp = async (phone, otp) => {
    await redisClient.set(`otp:${phone}`, otp.toString(), {
        EX: OTP_EXPIRY_SECONDS,
    });

};

exports.verifyOtp = async (phone, otp) => {
    const storedOtp = await redisClient.get(`otp:${phone}`);
    console.log("storedOtp", storedOtp)
    console.log("otp ", otp);
    const isValid = storedOtp === otp;
    if (isValid) {
        await redisClient.del(`otp:${phone}`);
    }
    return isValid;
};
