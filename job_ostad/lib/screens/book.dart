import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_ostad/utils/api_settings.dart';
import 'package:job_ostad/utils/constants.dart';
import 'package:job_ostad/utils/custom_theme.dart';
import 'package:job_ostad/widgets/bookList.dart';

class Book extends StatefulWidget {
  final Function(String, String) onClicked;
  const Book({required this.onClicked, super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  List<Map<String, dynamic>> allBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    ApiSettings apiSettings = ApiSettings(endPoint: 'book/get-all-books');
    try {
      final response = await apiSettings.getMethod();
      final data = jsonDecode(response.body);
      print(data);
      if (data['data'] != null) {
        setState(() {
          allBooks = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching books: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of other books
    final List<Map<String, String>> otherBooks = [
      {
        "title": "বাংলার ইতিহাস",
        "desc":
            "প্রাচীন থেকে আধুনিক বাংলার ইতিহাস, ঐতিহ্য, ও সংস্কৃতির একটি বিস্তৃত উপস্থাপনা।",
        "image": "https://i.ibb.co/6MsjtZK/ffb87d8816f5.jpg",
        "writter": "ড. মোহাম্মদ হান্নান",
      },
      {
        "title": "Physics for Competitive Exams",
        "desc":
            "Detailed physics concepts with MCQs and practice sets for job & university entrance exams.",
        "image": "https://i.ibb.co/6MsjtZK/ffb87d8816f5.jpg",
        "writter": "Dr. A. Rahman",
      },
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Most Downloaded Section
            _buildSectionTitle("Most Downloaded"),
            SizedBox(height: 10),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                spacing: 10.0,
                children:
                    allBooks
                        .map(
                          (book) => GestureDetector(
                            onTap: () {
                              widget.onClicked(book["title"], book["book_pdf"]);
                            },

                            child: Booklist(
                              title: book["title"] ?? "",
                              desc: book["description"] ?? "",
                              images: book["book_image"] ?? "",
                              writter: book["writer"] ?? "",
                            ),
                          ),
                        )
                        .toList(),
              ),
            SizedBox(height: 20),

            _buildSectionTitle("Others"),
            SizedBox(height: 10),
            Column(
              spacing: 10.0,
              children:
                  otherBooks
                      .map(
                        (book) => GestureDetector(
                          onTap: () {},

                          child: Booklist(
                            title: book["title"] ?? "",
                            desc: book["desc"] ?? "",
                            images: book["image"] ?? "",
                            writter: book["writter"] ?? "",
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
