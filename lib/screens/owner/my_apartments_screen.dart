import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/screens/owner/edit_apartment_screen.dart';

class MyApartmentsScreen extends StatefulWidget {
  const MyApartmentsScreen({super.key});

  @override
  State<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends State<MyApartmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments();
    });
  }

  List<Apartment> _getMockApartments() {
    return [
      Apartment(id: 101, title: 'My First Mock Apartment', description: 'Mock description', location: 'City Center', price: 120, bedrooms: 2, bathrooms: 1, area: 90, imageUrls: [], average_rating: 4.5, reviews_count: 15),
      Apartment(id: 102, title: 'My Second Mock Apartment', description: 'Mock description', location: 'Suburb Area', price: 95, bedrooms: 3, bathrooms: 2, area: 120, imageUrls: [], average_rating: 4.2, reviews_count: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Apartments'),
      ),
      body: Consumer<ApartmentProvider>(
        builder: (context, provider, child) {
          if (provider.status == ApartmentStatus.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ApartmentStatus.Error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          final apartments = provider.myApartments.isEmpty ? _getMockApartments() : provider.myApartments;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return _buildMyApartmentCard(context, apartments[index]);
            },
          );
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
                  child: Image.network(
                    apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : '',
                    width: 100, height: 100, fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Container(width: 100, height: 100, color: Colors.grey[200]),
                  ),
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
                      _buildRatingDisplay(theme, apartment),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditApartmentScreen(apartment: apartment)),
                    );
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text('View Bookings'),
                  onPressed: () { /* TODO */ },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDisplay(ThemeData theme, Apartment apartment) {
    final rating = apartment.average_rating ?? 0.0;
    final reviewCount = apartment.reviews_count ?? 0;
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text('$rating ($reviewCount reviews)', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
