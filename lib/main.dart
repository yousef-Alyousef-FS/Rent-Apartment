import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plproject/firebase_options.dart';
import 'package:plproject/screens/auth/login.dart';
import 'package:plproject/theme/app_theme.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before any async operations.
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase. If it fails (e.g., firebase_options.dart is missing),
  // the app will still run, but Firebase services will be unavailable.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed. App will run without Firebase services. Error: $e');
  }

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
