import 'package:flutter/material.dart';

import '../../utils/screen_size.dart';
import 'fontsizes.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.light(
      primary: Color(0xFF0b66cd),
      secondary: Color(0xFFD97706),
      background: Color(0xFFF8FAFC),
      surface: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1E293B),
      onBackground: Color(0xFF1E293B),
    ),
    scaffoldBackgroundColor: Color(0xFFF8FAFC),
    appBarTheme: AppBarTheme(
      color: Color(0xFF0b66cd),
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardColor: Color(0xFFFFFFFF),
    canvasColor: Color(0xFFF8FAFC),
    iconTheme: IconThemeData(color: Color(0xFF0b66cd)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFD97706),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: baseFontSize,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
      bodyMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.normal,
        color: Color(0xFF64748B),
      ),
      bodySmall: TextStyle(
        fontSize: ScreenSize.fontSize(12),
        fontWeight: FontWeight.normal,
        color: Color(0xFF94A3B8),
      ),
      titleLarge: TextStyle(
        fontSize: ScreenSize.fontSize(22),
        fontWeight: FontWeight.bold,
        color: Color(0xFF0b66cd),
      ),
      titleMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFA5B4FC),
      secondary: Color(0xFFFACC15),
      background: Color(0xFF0F172A),
      surface: Color(0xFF1E293B),
      onPrimary: Color(0xFF0F172A),
      onSecondary: Color(0xFF0F172A),
      onSurface: Color(0xFFF1F5F9),
      onBackground: Color(0xFFF1F5F9),
    ),
    scaffoldBackgroundColor: Color(0xFF0F172A),
    appBarTheme: AppBarTheme(
      color: Color(0xFF1E293B),
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: ScreenSize.fontSize(20),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardColor: Color(0xFF1E293B),
    canvasColor: Color(0xFF0F172A),
    iconTheme: IconThemeData(color: Color(0xFFA5B4FC)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFACC15),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: ScreenSize.fontSize(16),
        fontWeight: FontWeight.normal,
        color: Color(0xFFF1F5F9),
      ),
      bodyMedium: TextStyle(
        fontSize: ScreenSize.fontSize(14),
        fontWeight: FontWeight.normal,
        color: Color(0xFFCBD5E1),
      ),
      titleLarge: TextStyle(
        fontSize: ScreenSize.fontSize(22),
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
