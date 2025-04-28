const Quiz = require("../models/quiz.model");

exports.get_all_quiz = (req, res)=>{
    try {
        res.json({"message": "All the quiz successfully"})
    }
    catch (error) {
        res.status(500).json({"message": "Server error", error: error.message});
    }
}

exports.add_a_quiz = async (req, res)=>{
    try {
        const {title, description, collection, visibility, number_of_questions, total_time, keywords} = req.body;

        if(!title || !description || !collection || !visibility || !number_of_questions || !total_time || !keywords) {
            return res.status(400).json({ message: "All fields are required" });
        }

        const newQuiz = await Quiz.create({title, description, collection, visibility, number_of_questions, total_time, keywords})

        res.json({
            message: "Quiz created successfully",
            data: newQuiz
        });
    }
    catch (error) {
        res.status(500).json({message: "Server error", error: error.message});
    }
}
