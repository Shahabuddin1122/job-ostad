import 'package:flutter/material.dart';
import 'constants.dart';

class TBottomNavigationBarTheme {
  TBottomNavigationBarTheme._();

  // Light Theme
  static final BottomNavigationBarThemeData lightBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: PRIMARY_COLOR,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      );

  // Dark Theme
  static final BottomNavigationBarThemeData darkBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      );
}
