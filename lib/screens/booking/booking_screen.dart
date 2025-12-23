import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

class BookingScreen extends StatelessWidget {
   BookingScreen({super.key});

  // In a real app, this would be passed as an argument
  final Apartment mockApartment = Apartment(
    id: 1, title: 'Ocean View Villa', price: 250, location: 'Malibu, California', 
    bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250/FF5722/FFFFFF?Text=Villa'], 
    description: 'An amazing villa with a breathtaking ocean view.'
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Your Booking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildApartmentSummary(theme),
          const Divider(height: 32),
          _buildDateSelection(theme, context),
          const Divider(height: 32),
          _buildCostSummary(theme),
        ],
      ),
      bottomNavigationBar: _buildConfirmButton(theme),
    );
  }

  Widget _buildApartmentSummary(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            mockApartment.imageUrls.isNotEmpty ? mockApartment.imageUrls[0] : '',
            width: 100, height: 100, fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mockApartment.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(mockApartment.location, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateField(theme, context, title: 'Check-in', date: 'Sep 20, 2024'),
        const Icon(Icons.arrow_forward_rounded),
        _buildDateField(theme, context, title: 'Check-out', date: 'Sep 27, 2024'),
      ],
    );
  }

  Widget _buildDateField(ThemeData theme, BuildContext context, {required String title, required String date}) {
    return InkWell(
      onTap: () { /* TODO: Show date picker */ },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(date, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCostSummary(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price Details', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        _buildCostRow(theme, '\$250 x 7 nights', '\$1750'),
        const SizedBox(height: 8),
        _buildCostRow(theme, 'Service fee', '\$50'),
        const Divider(),
        _buildCostRow(theme, 'Total (USD)', '\$1800', isTotal: true),
      ],
    );
  }

  Widget _buildCostRow(ThemeData theme, String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) : theme.textTheme.bodyLarge),
          Text(amount, style: isTotal ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) : theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () { /* TODO: Navigate to BookingSuccessScreen */ },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Confirm & Pay'),
      ),
    );
  }
}
