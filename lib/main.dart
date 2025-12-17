import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/auth/auth_wrapper.dart';
import 'package:plproject/theme/app_theme.dart';

void main() async {
  // This is still needed for packages like shared_preferences to work before runApp.
  WidgetsFlutterBinding.ensureInitialized();

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
        home: const AuthWrapper(),
      ),
    );
  }
}
