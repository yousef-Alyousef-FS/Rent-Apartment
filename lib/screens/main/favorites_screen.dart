import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/widgets/apartment_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: Consumer2<UserProvider, ApartmentProvider>(
        builder: (context, userProvider, apartmentProvider, child) {

          // Filter the main list of apartments to get the favorites.
          final favoriteApartments = apartmentProvider.allApartments
              .where((apartment) => userProvider.isFavorite(apartment.id))
              .toList();

          // If the list of favorites is empty, show a message.
          if (favoriteApartments.isEmpty) {
            return const Center(
              child: Text(
                'Your favorite places will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Otherwise, display the list of favorite apartments.
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: favoriteApartments.length,
            itemBuilder: (context, index) {
              return ApartmentCard(apartment: favoriteApartments[index]);
            },
          );
        },
      ),
    );
  }
}
