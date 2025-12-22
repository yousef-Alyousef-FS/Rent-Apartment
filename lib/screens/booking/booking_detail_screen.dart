import 'package:flutter/material.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});

  // In a real app, the booking details would be passed as an argument

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: ListView(
        children: [
          // Placeholder for a map or image
          Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.map_outlined, size: 80, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ocean View Villa', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Malibu, California', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                const Divider(height: 32),

                _buildDetailRow(theme, Icons.calendar_today_outlined, 'Dates', 'Sep 20, 2024 - Sep 27, 2024'),
                _buildDetailRow(theme, Icons.night_shelter_outlined, 'Nights', '7'),
                _buildDetailRow(theme, Icons.people_outline, 'Guests', '2 Adults'),
                const Divider(height: 32),

                Text('Price Details', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                 _buildCostRow(theme, '\$250 x 7 nights', '\$1750'),
                 _buildCostRow(theme, 'Service fee', '\$50'),
                 const Divider(),
                 _buildCostRow(theme, 'Total Paid (USD)', '\$1800', isTotal: true),
                 const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.directions),
                        label: const Text('Get Directions'),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                     Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Booking'),
                        onPressed: () {},
                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(ThemeData theme, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
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
}
