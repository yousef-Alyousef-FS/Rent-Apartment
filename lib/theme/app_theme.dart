import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Define custom colors
  static const Color _primaryColor = Color(0xFF00897B); // A modern Teal
  static const Color _secondaryColor = Color(0xFFFFA000); // A warm Amber
  static const Color _lightBackgroundColor = Color(0xFFF7F9FA);
  static const Color _darkTextColor = Color(0xFF2C3E50);
  static const Color _lightTextColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,

    // Use Google Fonts for a more modern feel
    textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, color: _darkTextColor),
      displayMedium: TextStyle(fontWeight: FontWeight.bold, color: _darkTextColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: _darkTextColor),
      bodyLarge: TextStyle(color: _darkTextColor, height: 1.5),
      bodyMedium: TextStyle(color: Colors.black54, height: 1.5),
    )),

    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      onPrimary: _lightTextColor,
      onSecondary: _lightTextColor,
      background: _lightBackgroundColor,
      surface: Colors.white, // For cards and dialogs
      onBackground: _darkTextColor,
      onSurface: _darkTextColor,
      error: Colors.redAccent,
    ),

    appBarTheme: const AppBarTheme(
      color: _primaryColor,
      elevation: 4,
      iconTheme: IconThemeData(color: _lightTextColor),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600, // Slightly less bold
        color: _lightTextColor,
      ),
    ),

    // Card Theme for a softer look
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
    ),
    
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _secondaryColor,
      foregroundColor: _lightTextColor,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: _primaryColor, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.5),
      ),
    ),
  );
}
