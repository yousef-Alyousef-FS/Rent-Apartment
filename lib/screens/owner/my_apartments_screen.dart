import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

class MyApartmentsScreen extends StatelessWidget {
  const MyApartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for display
    final myApartments = [
      Apartment(id: 1, title: 'Ocean View Villa', price: 2800, location: 'Malibu, California', bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250/FF5722/FFFFFF?Text=Villa'], description: ''),
      Apartment(id: 2, title: 'Urban Chic Loft', price: 1500, location: 'SoHo, New York', bedrooms: 2, bathrooms: 2, area: 150, imageUrls: ['https://via.placeholder.com/400x250/4CAF50/FFFFFF?Text=Loft'], description: ''),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Apartments'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: myApartments.length,
        itemBuilder: (context, index) {
          return _buildMyApartmentCard(context, myApartments[index]);
        },
      ),
    );
  }

  Widget _buildMyApartmentCard(BuildContext context, Apartment apartment) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(apartment.imageUrls[0], width: 100, height: 100, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(apartment.title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(apartment.location, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text('4.8 (24 reviews)', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                  onPressed: () { /* TODO: Navigate to Edit Apartment */ },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('View Bookings'),
                  onPressed: () { /* TODO: Navigate to Owner Bookings */ },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
