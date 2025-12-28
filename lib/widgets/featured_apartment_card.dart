import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

class FeaturedApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const FeaturedApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias, // Ensures the image respects the card's rounded corners
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Expanded(
            flex: 3,
            child: Image.network(
              apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : '',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.apartment, size: 50, color: Colors.grey),
              ),
            ),
          ),
          // Text section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    apartment.location,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
