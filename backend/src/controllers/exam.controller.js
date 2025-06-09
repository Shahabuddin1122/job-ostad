const Question = require("../models/exam.model");
const { imgbb } = require("../services/imagebb.service");

exports.create_question = async (req, res) => {
  try {
    const { quiz_id } = req.body;
    let questions = JSON.parse(req.body.questions); // questions as array of objects

    const imageFiles = req.files || [];

    for (let i = 0; i < questions.length; i++) {
      const imageIndex = questions[i].imageIndex;

      if (imageIndex !== undefined && imageIndex !== null) {
        const fieldName = `images[${imageIndex}]`;
        const matchedFile = imageFiles.find(
          (file) => file.fieldname === fieldName
        );

        if (matchedFile) {
          const uploadedImage = await imgbb(matchedFile); // Upload to imgbb
          questions[i].image = uploadedImage.url; // Add image URL to question
        }
      }
    }

    await Question.createMultiple(quiz_id, questions);
    res
      .status(201)
      .json({ success: true, message: "Questions created successfully" });
  } catch (error) {
    console.error("Error creating questions:", error);
    res
      .status(500)
      .json({ success: false, message: "Failed to create questions" });
  }
};

// Get all questions for a quiz
exports.get_question = async (req, res) => {
  try {
    const { quizId } = req.params;

    if (!quizId) {
      return res
        .status(400)
        .json({ success: false, message: "quizId is required." });
    }

    const response = await Question.getAllQuestionOfAQuiz(quizId);

    const { exam_script_id, title, number_of_questions, total_time } =
      response[0];
    const questions = response.map((row) => ({
      id: row.question_id,
      question: row.question,
      options: row.options,
      answer: row.answer,
      image: row.image,
      subject: row.subject,
    }));

    res.status(200).json({
      success: true,
      data: {
        exam_script_id,
        title,
        number_of_questions,
        total_time,
        questions,
      },
    });
  } catch (error) {
    console.error("Error fetching questions:", error);
    res.status(500).json({ success: false, message: "Internal server error." });
  }
};

exports.update_or_add_questions = async (req, res) => {
  try {
    const { quiz_id } = req.body;
    let questions = JSON.parse(req.body.questions);

    if (!quiz_id) {
      return res.status(400).json({ success: false, message: "quiz_id is required" });
    }

    if (!Array.isArray(questions) || questions.length === 0) {
      return res.status(400).json({ success: false, message: "questions array is required" });
    }

    const imageFiles = req.files || [];

    for (let i = 0; i < questions.length; i++) {
      const imageIndex = questions[i].imageIndex;

      if (imageIndex !== undefined && imageIndex !== null) {
        const fieldName = `images[${imageIndex}]`;
        const matchedFile = imageFiles.find(file => file.fieldname === fieldName);

        if (matchedFile) {
          const uploadedImage = await imgbb(matchedFile); // Upload to imgbb
          questions[i].image = uploadedImage.url;
        }
      }
    }

    const exam_script_id = await Question.getExamScriptIdByQuizId(quiz_id);

    if (!exam_script_id) {
      return res.status(404).json({
        success: false,
        message: "No exam_script found for this quiz",
      });
    }

    for (const q of questions) {
      if (q.id) {
        await Question.updateQuestion(q); // Existing question
      } else {
        await Question.addSingleQuestion(exam_script_id, q); // New question
      }
    }

    res.status(200).json({ success: true, message: "Questions processed successfully" });
  } catch (error) {
    console.error("Error updating/adding questions:", error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
      error: error.message,
    });
  }
};
