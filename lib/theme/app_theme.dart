import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Core Colors
  static const Color primaryColor = Color(0xFF00796B); // A slightly deeper Teal
  static const Color secondaryColor = Color(0xFFFFB300); // A vibrant Amber
  static const Color backgroundColor = Color(0xFFF4F6F8);
  static const Color textColor = Color(0xFF34495E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF004D40)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Poppins', // Set the default font family

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      displayMedium: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: textColor),
      bodyLarge: TextStyle(color: textColor, height: 1.5),
      bodyMedium: TextStyle(color: Colors.black54, height: 1.5),
    ),

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      surface: Colors.white,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: textColor,
      onSurface: textColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      clipBehavior: Clip.antiAlias,
    ),
    
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.black,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: primaryColor, width: 2.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.redAccent, width: 2.5)),
    ),
  );
}
