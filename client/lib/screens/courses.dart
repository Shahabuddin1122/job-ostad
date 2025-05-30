import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:client/utils/api_settings.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/custom_theme.dart';
import 'package:client/widgets/SkeletonCourseItem.dart';
import 'package:client/widgets/categoryItem.dart';
import 'package:client/widgets/loading.dart';
import 'package:shimmer/shimmer.dart';

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
            isLoading
                ? SkeletonCourseItem()
                : allCourses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No courses available.")),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular Courses",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GridView.builder(
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
                    ],
                  ),
            const SizedBox(height: 20),
            isLoading
                ? SkeletonCourseItem()
                : allCourses.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No courses available.")),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Crash Course",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GridView.builder(
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
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
