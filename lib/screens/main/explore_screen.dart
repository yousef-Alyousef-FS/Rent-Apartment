import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/widgets/apartment_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // More mock data for a richer grid view
    final mockExploreApartments = [
      Apartment(id: 1, title: 'Sunny Studio', description: 'A sunny studio.', price: 950, location: 'East Village, New York', bedrooms: 1, bathrooms: 1, area: 50, imageUrls: ['https://via.placeholder.com/400x300/FFEB3B/000000?Text=Studio']),
      Apartment(id: 2, title: 'Garden Flat', description: 'A flat with a garden.', price: 1300, location: 'Greenwich, London', bedrooms: 2, bathrooms: 1, area: 80, imageUrls: ['https://via.placeholder.com/400x300/8BC34A/FFFFFF?Text=Garden']),
      Apartment(id: 3, title: 'Rooftop Penthouse', description: 'A penthouse with a rooftop.', price: 4500, location: 'Shibuya, Tokyo', bedrooms: 3, bathrooms: 3, area: 200, imageUrls: ['https://via.placeholder.com/400x300/E91E63/FFFFFF?Text=Penthouse']),
      Apartment(id: 4, title: 'Historic Townhouse', description: 'A historic townhouse.', price: 2100, location: 'Le Marais, Paris', bedrooms: 4, bathrooms: 2, area: 180, imageUrls: ['https://via.placeholder.com/400x300/9C27B0/FFFFFF?Text=Townhouse']),
      Apartment(id: 5, title: 'Beachfront Bungalow', description: 'A bungalow on the beach.', price: 3200, location: 'Bondi Beach, Sydney', bedrooms: 2, bathrooms: 2, area: 110, imageUrls: ['https://via.placeholder.com/400x300/03A9F4/FFFFFF?Text=Beach']),
      Apartment(id: 6, title: 'Mountain Cabin', description: 'A cabin in the mountains.', price: 1100, location: 'Aspen, Colorado', bedrooms: 3, bathrooms: 1, area: 130, imageUrls: ['https://via.placeholder.com/400x300/795548/FFFFFF?Text=Cabin']),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Apartments'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: mockExploreApartments.length,
        itemBuilder: (context, index) {
          final apartment = mockExploreApartments[index];
          return ApartmentCard(apartment: apartment);
        },
      ),
    );
  }
}
