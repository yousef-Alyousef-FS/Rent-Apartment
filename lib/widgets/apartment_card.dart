import 'package:flutter/material.dart';
import '../models/apartment.dart';
import '../screens/appartments/apartment_details_screen.dart'; // Import the details screen

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // Navigate to the details screen when the card is tapped.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailsScreen(apartment: apartment),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : 'https://via.placeholder.com/400x200?text=No+Image',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: theme.textTheme.headlineSmall, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(child: Text(apartment.location, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${apartment.price.toStringAsFixed(0)} / month', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.bed_outlined, size: 20), const SizedBox(width: 4), Text(apartment.bedrooms.toString()),
                          const SizedBox(width: 12),
                          const Icon(Icons.bathtub_outlined, size: 20), const SizedBox(width: 4), Text(apartment.bathrooms.toString()),
                        ],
                      ),
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
