import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plproject/providers/apartment_provider.dart';
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
    // The provider now gets the token from UserProvider automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
              if (provider.apartments.isEmpty) {
                return const Center(child: Text('No apartments available.'));
              }
              return ListView.builder(
                itemCount: provider.apartments.length,
                itemBuilder: (context, index) {
                  final apartment = provider.apartments[index];
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

  void _showLogoutDialog(BuildContext context) {
    // This should ideally use the UserProvider as well, but for now this is fine
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
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                if (mounted) {
                  Navigator.of(dialogContext).pop();
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
