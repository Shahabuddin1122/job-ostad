class TopCourse {
  final int id;
  final String title;
  final String description;
  final String category;
  final String keywords;
  final String courseImage;

  TopCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.keywords,
    required this.courseImage,
  });

  factory TopCourse.fromJson(Map<String, dynamic> json) {
    return TopCourse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      keywords: json['keywords'],
      courseImage: json['course_image'],
    );
  }
}
