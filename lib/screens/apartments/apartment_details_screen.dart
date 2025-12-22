import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

class ApartmentDetailsScreen extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Carousel
            _buildImageCarousel(context),

            // 2. Main Info Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(child: Text(apartment.location, style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('${apartment.price.toStringAsFixed(0)} / month', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  const Divider(height: 32, thickness: 1),

                  // 3. Specs Section
                  _buildSpecsRow(theme),
                  const Divider(height: 32, thickness: 1),
                  
                  // 4. Description
                  Text("Description", style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(apartment.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
      // 5. Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () { /* TODO: Implement booking logic */ },
        label: const Text("Book Now"),
        icon: const Icon(Icons.shopping_cart_checkout),
        backgroundColor: theme.colorScheme.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageCarousel(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: apartment.imageUrls.isNotEmpty ? apartment.imageUrls.length : 1,
        itemBuilder: (context, index) {
          final imageUrl = apartment.imageUrls.isNotEmpty 
              ? apartment.imageUrls[index] 
              : 'https://via.placeholder.com/400x250?text=No+Image';
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stack) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildSpecsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSpecItem(theme, Icons.bed_outlined, apartment.bedrooms.toString(), "Bedrooms"),
        _buildSpecItem(theme, Icons.bathtub_outlined, apartment.bathrooms.toString(), "Bathrooms"),
        _buildSpecItem(theme, Icons.area_chart_outlined, '${apartment.area} sqft', "Area"),
      ],
    );
  }

  Widget _buildSpecItem(ThemeData theme, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 30, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
