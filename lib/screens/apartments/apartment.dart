import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import '../../models/apartment.dart';
import '../../widgets/apartment_card.dart'; // Import the new custom widget

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
      final token = Provider.of<AuthProvider>(context, listen: false).user?.token;
      if (token != null) {
        Provider.of<ApartmentProvider>(context, listen: false).fetchApartments(token);
      }
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
                return const Center(child: Text('No apartments available at the moment.'));
              }
              // Now we just build a list of our custom ApartmentCard widgets
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        );
      },
    );
  }
}
