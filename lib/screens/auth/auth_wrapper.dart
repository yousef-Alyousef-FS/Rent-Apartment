import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/app_container.dart'; // Import the new container
import 'package:plproject/screens/auth/complete_profile.dart';
import 'package:plproject/screens/auth/login.dart';
import 'package:plproject/screens/auth/pending_approval_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Check for user status if logged in
        if (authProvider.authStatus == AuthStatus.Authenticated) {
          if (authProvider.user?.status == 'pending') {
            return const PendingApprovalScreen();
          }
          // Instead of returning a specific screen, return the main app container
          return const AppContainer();
        }

        // Handle other statuses
        switch (authProvider.authStatus) {
          case AuthStatus.CheckingAuth:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          
          case AuthStatus.NeedsProfileCompletion:
            return const CompleteProfile();

          case AuthStatus.Authenticating:
          case AuthStatus.Unauthenticated:
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
