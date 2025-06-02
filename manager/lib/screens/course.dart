import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/utils/api_settings.dart';
import 'package:manager/utils/constants.dart';
import 'package:manager/utils/custom_theme.dart';
import 'package:manager/widgets/course-item.dart';

class Course extends StatefulWidget {
  final Function(int) onClicked;
  const Course({required this.onClicked, super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  ApiSettings apiSettings = ApiSettings(endPoint: 'course/get-all-course');
  List<Map<String, dynamic>> allCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
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
              width: double.infinity,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add-course');
                },
                child: const Text("Add New Course"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Courses",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : allCourses.isEmpty
                ? const Text("No courses available.")
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: allCourses.length,
                    itemBuilder: (context, index) {
                      final course = allCourses[index];
                      return GestureDetector(
                        onTap: () => widget.onClicked(course['id']),
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
