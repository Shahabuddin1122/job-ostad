import 'package:flutter/material.dart';
import 'package:job_ostad/screens/book.dart';
import 'package:job_ostad/screens/book_view.dart';
import 'package:job_ostad/screens/courses.dart';
import 'package:job_ostad/screens/exam.dart';
import 'package:job_ostad/screens/exam_script.dart';
import 'package:job_ostad/screens/home.dart';
import 'package:job_ostad/screens/overview.dart';
import 'package:job_ostad/screens/profile.dart';
import 'package:job_ostad/screens/results.dart';
import 'package:job_ostad/utils/constants.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _isSearching = false;
  int _selectedIndex = 0; // Tracks the bottom navigation bar selection
  int _currentPageIndex = 0; // Tracks the current page being displayed
  String? selectedCourse;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPageIndex = index;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    print("User searched: $query");
                  },
                )
                : Text("MCQ OSTAD"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
            icon: Icon(Icons.notifications),
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
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
                BottomNavigationBarItem(
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
              backgroundColor: PRIMARY_COLOR,
              elevation: 4,
              shape: CircleBorder(),
              child: Icon(Icons.event, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentPageIndex) {
      case 0:
        return Home(
          onTextClicked: (String course) {
            setState(() {
              _currentPageIndex = 5; // Navigate to Courses
              selectedCourse = course;
            });
          },
        );
      case 1:
        return Book(
          onClicked: () {
            setState(() {
              _currentPageIndex = 7;
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
          onTextClicked: () {
            setState(() {
              _currentPageIndex = 6; // Navigate to Exam
            });
          },
        );
      case 6:
        return Exam();
      case 7:
        return BookView();
      default:
        return Home(
          onTextClicked: (String course) {
            setState(() {
              _currentPageIndex = 5;
              selectedCourse = course;
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
