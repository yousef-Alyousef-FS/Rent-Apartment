import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0D47A1), // A deep, trustworthy blue
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // A very light grey for the background

    // Define the default `AppBar` theme.
    appBarTheme: const AppBarTheme(
      color: Color(0xFF0D47A1), // Use the primary color for the AppBar
      iconTheme: IconThemeData(color: Colors.white), // White icons on the AppBar
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Define the default `TextButton` theme.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0D47A1), // Use primary color for text buttons
      ),
    ),

    // Define the default `ElevatedButton` theme.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D47A1), // Primary color for button background
        foregroundColor: Colors.white, // White text for buttons
      ),
    ),
    
    // Define the default `ColorScheme`.
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0D47A1), // Deep blue
      secondary: Color(0xFFFF6D00), // A vibrant orange for accents (FloatingActionButtons, etc.)
      onPrimary: Colors.white, // Text/icons on primary color
      onSecondary: Colors.white, // Text/icons on secondary color
      error: Colors.redAccent,
      background: Color(0xFFF5F5F5),
      onBackground: Colors.black87, // Text on background
      surface: Colors.white, // Cards, dialogs, etc.
      onSurface: Colors.black87, // Text on surface
    ),

    // Define the default `TextTheme` to be used across the app.
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
      displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
      headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
    ),
  );
}
