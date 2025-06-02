import 'package:flutter/material.dart';
import 'package:admin/screens/book.dart';
import 'package:admin/screens/course.dart';
import 'package:admin/screens/exam.dart';
import 'package:admin/screens/overview.dart';
import 'package:admin/screens/user.dart';
import 'package:admin/screens/view_book.dart';
import 'package:admin/utils/constants.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _isSearching = false;
  int _selectedIndex = 0;
  int _currentPageIndex = 0;
  int? _selectedCourseId;
  String? selectedBook, title;

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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (query) {
                    print("User searched: $query");
                  },
                )
              : Text("Job OSTAD"),
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
                color: Theme.of(
                  context,
                ).bottomNavigationBarTheme.backgroundColor,
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
      ),
    );
  }

  Widget _getBody() {
    switch (_currentPageIndex) {
      case 0:
        return Overview();
      case 1:
        return Book(
          onClicked: (String book_pdf, String Clickedtitle) {
            setState(() {
              selectedBook = book_pdf;
              title = Clickedtitle;
              _currentPageIndex = 6;
            });
          },
        );
      case 2:
        return Overview();
      case 3:
        return Course(
          onClicked: (int id) {
            setState(() {
              _selectedCourseId = id;
              _currentPageIndex = 5;
            });
          },
        );
      case 4:
        return User();
      case 5:
        return Exam(id: _selectedCourseId!);
      case 6:
        return BookView(book_pdf: selectedBook!, title: title!);
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
