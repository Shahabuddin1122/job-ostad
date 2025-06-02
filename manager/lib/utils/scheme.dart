import 'package:flutter/material.dart';
import 'package:manager/utils/appbar_theme_data.dart';
import 'package:manager/utils/bottom_navigationbar_theme.dart';
import 'package:manager/utils/constants.dart';
import 'package:manager/utils/elevated_button_theme.dart';
import 'package:manager/utils/text_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class Scheme {
  Scheme();

  static ThemeData _baseTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: PRIMARY_COLOR,
      scaffoldBackgroundColor: BACKGROUND,
      textTheme: TextThemes.lightTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      appBarTheme: TAppbarThemeData.lightAppbar,
      bottomNavigationBarTheme:
          TBottomNavigationBarTheme.lightBottomNavigationBarTheme,
      fontFamily: GoogleFonts.getFont('Inter').fontFamily,
    );
  }

  static ThemeData lightTheme = _baseTheme(Brightness.light);
  static ThemeData darkTheme = _baseTheme(Brightness.dark);
}
