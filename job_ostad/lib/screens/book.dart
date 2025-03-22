import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/bookList.dart';

class Book extends StatelessWidget {
  const Book({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Most Downloaded",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              spacing: 10,
              children: [
                Booklist(
                  title: "ATM এক টানা মুখস্থ - (লিখিত ও এমসিকিউ)",
                  desc:
                      "বাগধারা ॥ সমার্থক শব্দ ॥ বিপরীত শব্দ । এক কথায় প্রকাশ পারিভাষিক শব্দ ॥ বঙ্গানুবাদ ॥ প্রবাদ-প্রবচনসহ...",
                  images: "assets/images/books/ATM.jpg",
                  writter: "মোঃ আবু বকর সিদ্দিক",
                ),
                Booklist(
                  title: "বাংলার ইতিহাস",
                  desc:
                      "প্রাচীন থেকে আধুনিক বাংলার ইতিহাস, ঐতিহ্য, ও সংস্কৃতির একটি বিস্তৃত উপস্থাপনা।",
                  images: "assets/images/books/banglar_itihas.jpg",
                  writter: "ড. মোহাম্মদ হান্নান",
                ),
                Booklist(
                  title: "Physics for Competitive Exams",
                  desc:
                      "Detailed physics concepts with MCQs and practice sets for job & university entrance exams.",
                  images: "assets/images/books/physics.jpg",
                  writter: "Dr. A. Rahman",
                ),
                Booklist(
                  title: "Programming with Python",
                  desc:
                      "An easy-to-follow guide covering basic to advanced Python programming concepts.",
                  images: "assets/images/books/python.png",
                  writter: "John Doe",
                ),
                Booklist(
                  title: "মহাকাব্য: রামায়ণ ও মহাভারত",
                  desc:
                      "ভারতের দুটি প্রধান মহাকাব্যের সহজ ভাষায় সংকলন ও ব্যাখ্যা।",
                  images: "assets/images/books/mahabharat.jpg",
                  writter: "বিশ্বনাথ দত্ত",
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Others",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Booklist(
              title: "বাংলার ইতিহাস",
              desc:
                  "প্রাচীন থেকে আধুনিক বাংলার ইতিহাস, ঐতিহ্য, ও সংস্কৃতির একটি বিস্তৃত উপস্থাপনা।",
              images: "assets/images/books/banglar_itihas.jpg",
              writter: "ড. মোহাম্মদ হান্নান",
            ),
            Booklist(
              title: "Physics for Competitive Exams",
              desc:
                  "Detailed physics concepts with MCQs and practice sets for job & university entrance exams.",
              images: "assets/images/books/physics.jpg",
              writter: "Dr. A. Rahman",
            ),
          ],
        ),
      ),
    );
  }
}
