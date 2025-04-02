import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/course-item.dart';

class Course extends StatelessWidget {
  final VoidCallback onClicked;
  const Course({required this.onClicked, super.key});

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
                onPressed: () {},
                child: Text("Add New Course"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Courses",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onClicked,
              child: GridView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
