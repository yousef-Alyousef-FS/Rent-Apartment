import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/appartments/appartment.dart';
import 'package:plproject/screens/auth/complete_profile.dart';
import 'package:plproject/screens/auth/login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        switch (authProvider.authStatus) {
          case AuthStatus.CheckingAuth:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          
          case AuthStatus.NeedsProfileCompletion:
            return const CompleteProfile();

          case AuthStatus.Authenticated:
            return const Apartments();

          case AuthStatus.Authenticating:
          case AuthStatus.Unauthenticated:
          default:
            return const LoginScreen();
        }
      },
    );
  }
}
