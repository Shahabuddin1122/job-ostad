import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/categoryItem.dart';

class Courses extends StatelessWidget {
  final VoidCallback onTextClicked;
  const Courses({super.key, required this.onTextClicked});

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
                return GestureDetector(
                  onTap: onTextClicked,
                  child: items[index],
                );
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
