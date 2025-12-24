import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/app_container.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        switch (userProvider.status) {
          case UserStatus.Checking:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          
          case UserStatus.Authenticated:
            return const AppContainer(); // User is logged in, show the main app

          case UserStatus.Unauthenticated:
          default:
            return const WelcomeAuthScreen(); // User is not logged in, show the welcome screen
        }
      },
    );
  }
}
