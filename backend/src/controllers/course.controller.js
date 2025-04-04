exports.course = (req, res) => {
  res.status(200).json({ success: true, message: "Course api works fine" });
};

exports.addCourse = (req, res) => {
  res.json({ success: true });
};
