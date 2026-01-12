import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/generated/app_localizations.dart'; // Import localizations
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/screens/auth/welcome_auth_screen.dart';
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
      Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Localization instance

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.availableApartments),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: loc.logout,
            onPressed: () => _showLogoutDialog(context, loc),
          ),
        ],
      ),
      body: Consumer<ApartmentProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case ApartmentStatus.Loading:
              return const Center(child: CircularProgressIndicator());
            case ApartmentStatus.Error:
              // Using the error message with a placeholder
              return Center(child: Text(loc.errorOccurred(provider.errorMessage ?? 'Unknown error')));
            case ApartmentStatus.Loaded:
              if (provider.allApartments.isEmpty) {
                return Center(child: Text(loc.noApartmentsAvailable));
              }
              return ListView.builder(
                itemCount: provider.allApartments.length,
                itemBuilder: (context, index) {
                  final apartment = provider.allApartments[index];
                  return ApartmentCard(apartment: apartment);
                },
              );
            default: // Idle
              return Center(child: Text(loc.loadingApartments));
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmLogout),
          content: Text(loc.areYouSureLogout),
          actions: <Widget>[
            TextButton(child: Text(loc.cancel), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: Text(loc.logout, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false).logout();
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
