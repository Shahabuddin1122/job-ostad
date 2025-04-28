const express = require("express");
const authRoutes = require("./auth.routes");
const testRoutes = require("./test.routes");
const bookRoutes = require("./book.routes");
const courseRoutes = require("./course.routes");
const quizRouters = require("./quiz.routes");
const examRouters = require("./exam.routes");

const router = express.Router();

router.use("/auth", authRoutes);
router.use("/test", testRoutes);
router.use("/book", bookRoutes);
router.use("/course", courseRoutes);
router.use("/quiz", quizRouters);
router.use("/exam", examRouters)

module.exports = router;
