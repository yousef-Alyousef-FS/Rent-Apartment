import 'package:flutter/material.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Pending'),
        automaticallyImplyLeading: false, // Prevent the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Navigate back to the welcome screen and remove all routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Your Account is Under Review',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your registration has been submitted successfully. Please wait for the admin to approve your account. You will be able to log in once your account is approved.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
