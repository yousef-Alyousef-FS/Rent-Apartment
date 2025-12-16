import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:plproject/firebase_options.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/auth/auth_wrapper.dart'; // Import the new wrapper
import 'package:plproject/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rent Apartments",
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(), // Set the AuthWrapper as the home widget
      ),
    );
  }
}
