const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user.model");
const { send_sms } = require("../services/sms.service");
const { saveOtp, verifyOtp } = require("../utils/verify_sms.utils"); // new module

exports.register = async (req, res) => {
  try {
    const { phone_number } = req.body;

    const existingUser = await User.findOne('phone_number', phone_number);
    // if (existingUser) {
    //   return res.status(400).json({ message: "Phone number already in use" });
    // }

    const otp = Math.floor(100000 + Math.random() * 900000);
    saveOtp(phone_number, otp);

    const smsSent = await send_sms(phone_number, `Your Alpha Net OTP Code is ${otp}`);
    if (!smsSent) {
      return res.status(500).json({ message: "Failed to send OTP" });
    }

    res.status(200).json({ message: "OTP sent successfully" });
  } catch (error) {
    res.status(500).json({ message: "Registration initiation failed", error: error.message });
  }
};

exports.verifyOtpAndRegister = async (req, res) => {
  try {
    const { username, email, phone_number, education, password, otp } = req.body;

    if (!verifyOtp(phone_number, otp)) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    const existingUser = await User.findOne('phone_number', phone_number);
    if (existingUser) {
      return res.status(400).json({ message: "Phone number already in use" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      username,
      email,
      phone_number,
      education,
      password: hashedPassword
    });

    res.status(201).json({ message: "User registered successfully", user });
  } catch (error) {
    res.status(500).json({ message: "Registration failed", error: error.message });
  }
};


exports.login = async (req, res) => {
  try {
    const { phone_number, password } = req.body;
    const user = await User.findOne("phone_number", phone_number);

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
      expiresIn: "24h",
    });

    res.json({ message: "Login successful", token });
  } catch (error) {
    res.status(500).json({ message: "Login failed", error });
  }
};

exports.get_user = async (req, res) => {
  try {
      const allUser = await User.getAll();
      res.status(200).json({status: true, message: allUser})
  }
  catch (e) {
    res.status(500).json({status: false, message: `server error ${e}`})
  }
}