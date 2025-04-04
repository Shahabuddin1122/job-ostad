const express = require("express");
const authRoutes = require("./auth.routes");
const testRoutes = require("./test.routes");
const bookRoutes = require("./book.routes");

const router = express.Router();

router.use("/auth", authRoutes);
router.use("/test", testRoutes);
router.use("/book", bookRoutes);

module.exports = router;
