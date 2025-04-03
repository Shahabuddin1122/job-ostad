import 'package:flutter/material.dart';
import 'package:job_ostad/screens/book.dart';
import 'package:job_ostad/screens/course.dart';
import 'package:job_ostad/screens/exam.dart';
import 'package:job_ostad/screens/overview.dart';
import 'package:job_ostad/screens/user.dart';
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
                _buildNavItem(Icons.dashboard, "Dashboard", 0),
                _buildNavItem(Icons.import_contacts, "Book", 1),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "",
                ), // Empty item for FAB
                _buildNavItem(Icons.book, "Course", 3),
                _buildNavItem(Icons.group, "Users", 4),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-quiz');
              },
              backgroundColor: PRIMARY_COLOR,
              elevation: 4,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentPageIndex) {
      case 0:
        return Overview();
      case 1:
        return Book();
      case 2:
        return Overview();
      case 3:
        return Course(
          onClicked: () {
            setState(() {
              _currentPageIndex = 5;
            });
          },
        );
      case 4:
        return User();
      case 5:
        return Exam();

      default:
        return Overview();
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
