const express = require("express");
const { register, login, get_user, verifyOtpAndRegister} = require("../controllers/auth.controller");
const { authenticateToken } = require("../middlewares/auth.middleware");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.get("/get-all-user", authenticateToken, get_user)
router.post("/verify-register", verifyOtpAndRegister)

module.exports = router;
