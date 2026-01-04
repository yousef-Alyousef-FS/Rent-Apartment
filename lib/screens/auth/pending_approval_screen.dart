import 'package:flutter/material.dart';
import 'package:plproject/generated/app_localizations.dart'; // Import localizations
import 'package:plproject/screens/auth/welcome_auth_screen.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.registrationPending),
        automaticallyImplyLeading: false, // Prevent the back button
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
                loc.yourAccountIsUnderReview,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                loc.pendingApprovalMessage,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      // --- UPDATED: A clearer button to go back to the home/welcome screen ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          child: Text(loc.backToHome),
          onPressed: () {
            // Navigate back to the welcome screen and remove all routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }
}
