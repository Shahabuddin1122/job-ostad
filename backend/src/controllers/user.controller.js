const User = require("../models/user.model");
exports.add_user = async (req, res)=>{
    try {
        const {username, email, phone_number, education, password} = req.body;
        if(!username || !phone_number || !education || !password)
            res.status(500).json({status: false, message: "Fields can't be null"})

        const new_user = await User.create({username, email, phone_number, education, password})


        res.json({status: true, message: new_user})
    }
    catch (e) {
        res.status(500).json({status: false, message: `Server error: ${e}`})
    }
}