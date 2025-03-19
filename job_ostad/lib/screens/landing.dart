import 'package:flutter/material.dart';
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
      body: Center(child: Text("Welcome to MCQ OSTAD!")),
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
                BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""),
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
                  _selectedIndex = 2;
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

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
