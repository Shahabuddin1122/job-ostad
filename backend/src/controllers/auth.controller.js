const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user.model");

exports.register = async (req, res) => {
  try {
    const { username, email, phone_number, education, password } = req.body;

    const existingUser = await User.findOne( 'phone_number', phone_number );
    if (existingUser) {
      return res.status(400).json({ message: "Phone number already in use" });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create new user
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

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
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