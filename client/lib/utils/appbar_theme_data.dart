import 'package:flutter/material.dart';
import 'constants.dart';

class TAppbarThemeData {
  TAppbarThemeData();

  static const lightAppbar = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: PRIMARY_COLOR,
    iconTheme: IconThemeData(size: 24, color: Colors.white),
    actionsIconTheme: IconThemeData(size: 24, color: Colors.white),
    surfaceTintColor: PRIMARY_COLOR,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static const darkAppbar = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: BACKGROUND,
    iconTheme: IconThemeData(size: 24, color: TEXT),
    actionsIconTheme: IconThemeData(size: 24, color: BACKGROUND),
    surfaceTintColor: BACKGROUND,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: BACKGROUND,
    ),
  );
}
