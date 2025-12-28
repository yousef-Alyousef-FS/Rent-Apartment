import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/apartments/apartment_details_screen.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ApartmentDetailsScreen(apartment: apartment),
        ));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context), // Pass context
            _buildInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Image.network(
          apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : '',
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.apartment, size: 60, color: Colors.grey)),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final isFavorited = userProvider.isFavorite(apartment.id);
              return IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  userProvider.toggleFavorite(apartment.id);
                },
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '\$${apartment.price}/night',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(apartment.title, style: theme.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(apartment.location, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text('4.8', style: theme.textTheme.bodyLarge), // Mock rating
                ],
              ),
              Text('${apartment.bedrooms} beds  ·  ${apartment.bathrooms} baths', style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
