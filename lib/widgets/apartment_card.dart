import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/apartments/apartment_details_screen.dart';
import 'package:plproject/generated/app_localizations.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApartmentDetailsScreen(apartment: apartment),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // CORRECTED TYPO
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Image.network(
                      apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : '',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(height: 200, color: Colors.grey[200], child: const Center(child: Icon(Icons.apartment, size: 60, color: Colors.grey)))),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final isFavorited = userProvider.isFavorite(apartment.id);
                      return IconButton(
                        icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border, color: isFavorited ? Colors.red : Colors.white),
                        onPressed: () => userProvider.toggleFavorite(apartment.id),
                        style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.3)),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  if (apartment.city != null && apartment.governorate != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${apartment.city}, ${apartment.governorate}',
                            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '\$${apartment.price.toStringAsFixed(0)}', style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
                            TextSpan(text: loc.perNight, style: theme.textTheme.bodyMedium), // LOCALIZED
                          ],
                        ),
                      ),
                      if (apartment.average_rating != null && apartment.average_rating! > 0)
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(apartment.average_rating!.toStringAsFixed(1), style: theme.textTheme.bodyLarge),
                          ],
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
