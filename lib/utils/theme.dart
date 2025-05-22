import 'package:flutter/material.dart';

import '../../utils/screen_size.dart';
import 'fontsizes.dart';

class AppTheme {
  // Define light theme
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    // App Bar Theme
    bottomAppBarTheme: BottomAppBarTheme(
      color: Color(0xffFCFCFF),
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xff040F4F), // Customize app bar color
      elevation: 0,
      toolbarTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    // Primary Color
    primaryColor: Color(0xff040F4F),
    secondaryHeaderColor: Color(0xffF9B406),
    cardColor: Color(0xffa3aacf),
    canvasColor: Color(0xffe3e7ff),
    // Scaffolding Background Color
    scaffoldBackgroundColor: Colors.white,
    // Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: baseFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
      bodySmall: TextStyle(
        fontSize: ScreenSize.fontSize(12),
        fontWeight: FontWeight.normal,
        color: Colors.black54,
      ),
      titleLarge: TextStyle(
        fontSize: ScreenSize.fontSize(22),
        fontWeight: FontWeight.w600,
        color: Color(0xff040F4F),
      ),
      titleMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.w600,
        color: Color(0xff040F4F),
      ),
    ),
    // Button Theme
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    // Icon Theme
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  );

  // Define dark theme
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    // App Bar Theme
    appBarTheme: AppBarTheme(
      color: Colors.black, // Customize app bar color
      elevation: 0,
      toolbarTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    // Primary Color
    primaryColor: Colors.blueGrey,
    // Scaffolding Background Color
    scaffoldBackgroundColor: Colors.black,
    // Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: ScreenSize.fontSize(16),
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      titleLarge: TextStyle(
        fontSize: ScreenSize.fontSize(22),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    // Button Theme
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueGrey,
      textTheme: ButtonTextTheme.primary,
    ),
    // Icon Theme
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
    ),
  );
}
