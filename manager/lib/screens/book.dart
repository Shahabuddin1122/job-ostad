import 'package:flutter/material.dart';
import 'package:manager/utils/api_settings.dart';
import 'package:manager/utils/constants.dart';
import 'package:manager/utils/custom_theme.dart';
import 'package:manager/widgets/bookList.dart';
import 'dart:convert';

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
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    ApiSettings apiSettings = ApiSettings(endPoint: 'book/get-all-books');
    try {
      final response = await apiSettings.getMethod();
      final data = jsonDecode(response.body);

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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: Theme.of(context).defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Books",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: allBooks
                        .map(
                          (book) => GestureDetector(
                            onTap: () {
                              widget.onClicked(book["book_pdf"], book["title"]);
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
            label: const Text(
              "Add New Book",
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
