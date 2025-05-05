const express = require('express')
const {add_user} = require("../controllers/user.controller");

const router = express.Router()

router.post('/sign-up', add_user)

module.exports = router;