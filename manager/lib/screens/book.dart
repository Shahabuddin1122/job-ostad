import 'package:flutter/material.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/bookList.dart';

class Book extends StatelessWidget {
  const Book({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> allBooks = [
      {
        "title": "ATM এক টানা মুখস্থ - (লিখিত ও এমসিকিউ)",
        "desc":
            "বাগধারা ॥ সমার্থক শব্দ ॥ বিপরীত শব্দ । এক কথায় প্রকাশ পারিভাষিক শব্দ ॥ বঙ্গানুবাদ ॥ প্রবাদ-প্রবচনসহ...",
        "image": "assets/images/books/ATM.jpg",
        "writter": "মোঃ আবু বকর সিদ্দিক",
      },
      {
        "title": "বাংলার ইতিহাস",
        "desc":
            "প্রাচীন থেকে আধুনিক বাংলার ইতিহাস, ঐতিহ্য, ও সংস্কৃতির একটি বিস্তৃত উপস্থাপনা।",
        "image": "assets/images/books/banglar_itihas.jpg",
        "writter": "ড. মোহাম্মদ হান্নান",
      },
      {
        "title": "Physics for Competitive Exams",
        "desc":
            "Detailed physics concepts with MCQs and practice sets for job & university entrance exams.",
        "image": "assets/images/books/physics.jpg",
        "writter": "Dr. A. Rahman",
      },
      {
        "title": "Programming with Python",
        "desc":
            "An easy-to-follow guide covering basic to advanced Python programming concepts.",
        "image": "assets/images/books/python.png",
        "writter": "John Doe",
      },
      {
        "title": "মহাকাব্য: রামায়ণ ও মহাভারত",
        "desc": "ভারতের দুটি প্রধান মহাকাব্যের সহজ ভাষায় সংকলন ও ব্যাখ্যা।",
        "image": "assets/images/books/mahabharat.jpg",
        "writter": "বিশ্বনাথ দত্ত",
      },
    ];

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: Theme.of(context).defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  "Books",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children:
                      allBooks
                          .map(
                            (book) => GestureDetector(
                              onTap: () {},
                              child: Booklist(
                                title: book["title"]!,
                                desc: book["desc"]!,
                                images: book["image"]!,
                                writter: book["writter"]!,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/add-book');
            },
            backgroundColor: PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            label: Text("Add New Book", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
