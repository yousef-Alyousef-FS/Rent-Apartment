import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';

class Apartments extends StatelessWidget {
  const Apartments({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user's first name from the provider to personalize the welcome message
    final userFirstName = Provider.of<AuthProvider>(context).user?.firstName ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Apartments"),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Show a confirmation dialog before logging out
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Logout'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          // Call the logout method from the provider
                          Provider.of<AuthProvider>(context, listen: false).logout();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        child: Text(
          "Welcome, $userFirstName!",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
