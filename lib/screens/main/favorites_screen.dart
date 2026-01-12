import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/apartment.dart';
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/widgets/apartment_card.dart';
import 'package:sakani/generated/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.favoritesTitle),
      ),
      body: Consumer2<UserProvider, ApartmentProvider>(
        builder: (context, userProvider, apartmentProvider, child) {

          final favoriteApartments = apartmentProvider.allApartments
              .where((apartment) => userProvider.isFavorite(apartment.id))
              .toList();

          if (favoriteApartments.isEmpty) {
            return Center(
              child: Text(
                loc.noFavoritesMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

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
