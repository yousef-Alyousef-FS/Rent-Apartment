import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/widgets/apartment_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock data for display
    final mockApartments = [
      Apartment(id: 1, title: 'Ocean View Villa', price: 2800, location: 'Malibu, California', bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250/FF5722/FFFFFF?Text=Villa'], description: ''),
      Apartment(id: 2, title: 'Urban Chic Loft', price: 1500, location: 'SoHo, New York', bedrooms: 2, bathrooms: 2, area: 150, imageUrls: ['https://via.placeholder.com/400x250/4CAF50/FFFFFF?Text=Loft'], description: ''),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Home!', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
            Text('Yasser Otani', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
            onPressed: () { /* TODO: Navigate to notifications */ },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: ListView(
        children: [
          _buildSearchBar(context),
          _buildCategoryList(context),
          _buildSectionHeader(context, 'Featured Apartments'),
          // Using the ApartmentCard we already built
          ...mockApartments.map((apartment) => ApartmentCard(apartment: apartment)).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for a city, neighborhood, or address...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final categories = ['For You', 'Popular', 'Near You', 'New'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(categories[index]),
              backgroundColor: index == 0 ? Theme.of(context).primaryColor : Colors.white,
              labelStyle: TextStyle(color: index == 0 ? Colors.white : Colors.black),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }
}
