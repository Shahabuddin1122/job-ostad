import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/categoryItem.dart';

class Courses extends StatefulWidget {
  final Function(String) onTextClicked;
  final String course;
  const Courses({required this.course, super.key, required this.onTextClicked});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List<Map<String, dynamic>> allCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    ApiSettings apiSettings = ApiSettings(
      endPoint: 'course/get-courses-by-category?category=${widget.course}',
    );
    try {
      final response = await apiSettings.getMethod();
      final data = jsonDecode(response.body);
      if (data['message'] != null && data['message'] is List) {
        setState(() {
          allCourses = List<Map<String, dynamic>>.from(data['message']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching courses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: PRIMARY_COLOR),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: PRIMARY_COLOR.withAlpha(100),
                    offset: Offset(2, 4),
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: PRIMARY_COLOR,
                    width: double.maxFinite,
                    padding: Theme.of(context).insideCardPadding,
                    child: Text(
                      "Free model test",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/exam-script');
                    },
                    child: Container(
                      padding: Theme.of(context).insideCardPadding,
                      width: double.maxFinite,
                      color: Colors.white,
                      child: Column(
                        spacing: 5.0,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "আন্তর্জাতিক সম্পর্ক-01",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text("Question: 20"),
                          Text("Time: 10 minutes"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Popular Exam",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : allCourses.isEmpty
                ? const Text("No courses available.")
                : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: allCourses.length,
                  itemBuilder: (context, index) {
                    final course = allCourses[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onTextClicked(course['id'].toString());
                      },
                      child: CategoryItem(
                        imagePath: course['course_image'] ?? '',
                        title: course['title'] ?? 'No Title',
                      ),
                    );
                  },
                ),
            Text(
              "Crash Course",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : allCourses.isEmpty
                ? const Text("No courses available.")
                : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: allCourses.length,
                  itemBuilder: (context, index) {
                    final course = allCourses[index];
                    return GestureDetector(
                      onTap: () => widget.onTextClicked,
                      child: CategoryItem(
                        imagePath: course['course_image'] ?? '',
                        title: course['title'] ?? 'No Title',
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
