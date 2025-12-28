import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/app_container.dart';
import 'package:plproject/screens/auth/pending_approval_screen.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        switch (userProvider.status) {
          case UserStatus.Checking:
          case UserStatus.Loading:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          
          case UserStatus.Authenticated:
            // First, check if the user object itself is loaded.
            // This prevents a flicker or error if the state updates 
            // before the user data is fully populated in the provider.
            if (userProvider.user == null) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // After confirming user object is available, check their status.
            if (userProvider.user!.status == 'pending') {
              return const PendingApprovalScreen();
            } else {
              // If approved or any other status, go to the main app
              return const AppContainer(); 
            }

          case UserStatus.Unauthenticated:
          case UserStatus.Error:
          default:
            return const WelcomeAuthScreen();
        }
      },
    );
  }
}
