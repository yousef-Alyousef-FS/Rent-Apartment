import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/screens/admin/admin_dashboard_screen.dart'; // Will create this next
import 'package:plproject/screens/admin/admin_login_screen.dart';
import 'package:plproject/theme/app_theme.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rental App - Admin Panel",
        theme: AppTheme.lightTheme,
        home: const AdminAuthWrapper(), // Use a wrapper to handle auth state
      ),
    );
  }
}

// This wrapper listens to the AdminProvider and shows the correct screen.
class AdminAuthWrapper extends StatelessWidget {
  const AdminAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isAdminLoggedIn) {
          return const AdminDashboardScreen();
        } else {
          return const AdminLoginScreen();
        }
      },
    );
  }
}
