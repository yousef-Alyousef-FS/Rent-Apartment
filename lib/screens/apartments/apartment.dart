import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/user_provider.dart'; // Import UserProvider
import 'package:plproject/screens/auth/welcome_auth_screen.dart';
import '../../widgets/apartment_card.dart';

class Apartments extends StatefulWidget {
  const Apartments({super.key});

  @override
  State<Apartments> createState() => _ApartmentsState();
}

class _ApartmentsState extends State<Apartments> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the correct provider method to fetch data for this screen
      Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Apartments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Consumer<ApartmentProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case ApartmentStatus.Loading:
              return const Center(child: CircularProgressIndicator());
            case ApartmentStatus.Error:
              return Center(child: Text('Error: ${provider.errorMessage}'));
            case ApartmentStatus.Loaded:
              // --- CORRECTED: Use `allApartments` instead of `apartments` ---
              if (provider.allApartments.isEmpty) {
                return const Center(child: Text('No apartments available.'));
              }
              return ListView.builder(
                itemCount: provider.allApartments.length,
                itemBuilder: (context, index) {
                  final apartment = provider.allApartments[index];
                  return ApartmentCard(apartment: apartment);
                },
              );
            default: // Idle
              return const Center(child: Text('Welcome! Loading apartments...'));
          }
        },
      ),
    );
  }

  // --- CORRECTED: Logout logic now uses UserProvider ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                // Use the provider to handle logout logic centrally
                await Provider.of<UserProvider>(context, listen: false).logout();
                
                if (mounted) {
                  // Navigate to the welcome screen after logout
                  Navigator.of(dialogContext).pop(); // Close the dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
