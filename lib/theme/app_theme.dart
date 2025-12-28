import 'package:flutter/material.dart';

class AppTheme {

  static final Color _primaryColor = Colors.teal;
  static final Color _scaffoldBackgroundColor = Colors.grey.shade100;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: Colors.amber,
      background: _scaffoldBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    // Define other theme properties...
  );

  // --- Step 2.A: Add the dark theme definition ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade800,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      secondary: Colors.amber,
      background: Colors.grey.shade900,
      surface: Colors.grey.shade800,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
    ),
    // Adapt other properties for dark mode
  );
}
