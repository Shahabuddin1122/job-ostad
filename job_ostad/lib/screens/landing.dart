import 'package:flutter/material.dart';
import 'package:job_ostad/screens/book.dart';
import 'package:job_ostad/screens/book_view.dart';
import 'package:job_ostad/screens/courses.dart';
import 'package:job_ostad/screens/exam.dart';
import 'package:job_ostad/screens/home.dart';
import 'package:job_ostad/utils/constants.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _isSearching = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      body: BookView(),
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
                _buildNavItem(Icons.book, "Book", 3),
                BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""),
                _buildNavItem(Icons.bar_chart, "Result", 5),
                _buildNavItem(Icons.person, "Profile", 6),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
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
    switch (_selectedIndex) {
      case 0:
        return Home(
          onTextClicked: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        );
      case 1:
        return Courses(
          onTextClicked: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
        );
      case 2:
        return Exam();
      case 3:
        return Book();
      default:
        return Home(
          onTextClicked: () {
            setState(() {
              _selectedIndex = 1;
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
