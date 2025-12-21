import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/screens/admin/admin_dashboard_screen.dart';
import 'package:plproject/theme/app_theme.dart';

// This is the entry point for running a specific widget in a test environment.
void main() {
  runApp(const UITestbedApp());
}

class UITestbedApp extends StatelessWidget {
  const UITestbedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Create the provider and immediately call loadMockData.
      create: (context) => AdminProvider()..loadMockData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "UI Testbed",
        theme: AppTheme.lightTheme,
        // Directly display the screen you want to test.
        home: const AdminDashboardScreen(),
      ),
    );
  }
}
