import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          
          // Filter the main apartment list to get only the favorite ones.
          final favoriteApartments = apartmentProvider.apartments
              .where((apartment) => userProvider.isFavorite(apartment.id))
              .toList();

          if (favoriteApartments.isEmpty) {
            return const Center(
              child: Text(
                'You haven\'t added any apartments to your favorites yet.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteApartments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ApartmentCard(apartment: favoriteApartments[index]),
              );
            },
          );
        },
      ),
    );
  }
}
