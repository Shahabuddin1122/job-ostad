import 'package:flutter/material.dart';
import 'package:client/screens/book.dart';
import 'package:client/screens/book_view.dart';
import 'package:client/screens/courses.dart';
import 'package:client/screens/exam.dart';
import 'package:client/screens/exam_script.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/overview.dart';
import 'package:client/screens/profile.dart';
import 'package:client/screens/results.dart';
import 'package:client/utils/constants.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _isSearching = false;
  int _selectedIndex = 0;
  int _currentPageIndex = 0; // Tracks the current page being displayed
  String? selectedCourse;
  String? courseId;
  String? selectedBookPdf;
  String? selectedBookTitle;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPageIndex = index;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  // Handle back button press
  Future<void> _onPopInvokedWithResult(bool didPop, dynamic result) async {
    if (didPop) return; // Allow pop if no custom handling
    if (_currentPageIndex != 0) {
      // If not on Overview, go back to Overview
      setState(() {
        _currentPageIndex = 0;
        _selectedIndex = 0;
      });
    } else {
      final bool shouldPop =
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Exit
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
      if (shouldPop && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    print("User searched: $query");
                  },
                )
              : const Text("Job OSTAD"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                print("Notification clicked");
              },
            ),
          ],
        ),
        body: _getBody(),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: PRIMARY_COLOR,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  _buildNavItem(Icons.home, "Home", 0),
                  _buildNavItem(Icons.book, "Book", 1),
                  const BottomNavigationBarItem(
                    icon: SizedBox.shrink(),
                    label: "",
                  ), // Empty item for FAB
                  _buildNavItem(Icons.bar_chart, "Result", 3),
                  _buildNavItem(Icons.person, "Profile", 4),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2; // Index for the floating action button
                    _currentPageIndex = 2; // Navigate to Exam
                  });
                },
                backgroundColor: SECONDARY_BACKGROUND,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.event, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    switch (_currentPageIndex) {
      case 0:
        return Home(
          onTextClicked: (String? course, String courseid, int pageId) {
            setState(() {
              _currentPageIndex = pageId; // Navigate to Courses
              selectedCourse = course;
              courseId = courseid;
            });
          },
        );
      case 1:
        return Book(
          onClicked: (String title, String pdf) {
            setState(() {
              _currentPageIndex = 7;
              selectedBookPdf = pdf;
              selectedBookTitle = title;
            });
          },
        );
      case 2:
        return Overview();
      case 3:
        return Results();
      case 4:
        return Profile();
      case 5:
        return Courses(
          course: selectedCourse!,
          onTextClicked: (String id) {
            setState(() {
              _currentPageIndex = 6; // Navigate to Exam
              courseId = id;
            });
          },
        );
      case 6:
        return Exam(id: courseId!);
      case 7:
        return BookView(book_pdf: selectedBookPdf!, title: selectedBookTitle!);
      default:
        return Home(
          onTextClicked: (String? course, String courseid, int pageId) {
            setState(() {
              _currentPageIndex = pageId;
              selectedCourse = course;
              courseId = courseid;
            });
          },
        );
    }
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
