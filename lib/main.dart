import 'package:flutter/material.dart';
import 'package:plproject/screens/auth/login.dart';
import 'package:plproject/theme/app_theme.dart'; // Import the theme

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rent Apartments",
      theme: AppTheme.lightTheme, // Apply the light theme
      home: const LoginScreen(),
    );
  }
}
