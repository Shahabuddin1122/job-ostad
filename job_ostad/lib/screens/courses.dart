import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/categoryItem.dart';

class Courses extends StatelessWidget {
  const Courses({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Popular Exam",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: 2,
              itemBuilder: (context, index) {
                final items = [
                  CategoryItem(
                    imagePath:
                        "assets/images/Lamp, books and objects for studying.png",
                    title: "47th BCS CRASH COURSE",
                  ),
                  CategoryItem(
                    imagePath:
                        "assets/images/Young woman doing her homework.png",
                    title: "BANK PROSTUTI",
                  ),
                ];
                return items[index];
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Crash Course",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final items = [
                  CategoryItem(
                    imagePath:
                        "assets/images/Textbook with mortarboard for education.png",
                    title: "47th BCS CRASH COURSE",
                  ),
                  CategoryItem(
                    imagePath:
                        "assets/images/Standardized test as method of assessment.png",
                    title: "BANK PROSTUTI",
                  ),
                  CategoryItem(
                    imagePath:
                        "assets/images/stack of books and mug next to laptop screen showing planets.png",
                    title: "47th BCS CRASH COURSE",
                  ),
                  CategoryItem(
                    imagePath:
                        "assets/images/Online lesson and distance learning.png",
                    title: "BANK PROSTUTI",
                  ),
                  CategoryItem(
                    imagePath: "assets/images/exam paper.png",
                    title: "BANK PROSTUTI",
                  ),
                ];
                return items[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}
