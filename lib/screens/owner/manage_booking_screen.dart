import 'package:flutter/material.dart';

class ManageBookingScreen extends StatelessWidget {
  const ManageBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Booking Request'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Renter Information
          _buildSectionHeader(theme, 'Renter Information'),
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Yasser Otani'), // Mock renter name
              subtitle: Text('Joined: Jan 2024'),
            ),
          ),
          const SizedBox(height: 24),

          // Booking Details
          _buildSectionHeader(theme, 'Booking Details'),
          _buildDetailRow(theme, Icons.apartment_outlined, 'Apartment', 'Ocean View Villa'),
          _buildDetailRow(theme, Icons.calendar_today_outlined, 'Dates', 'Oct 10 - Oct 15, 2024'),
          _buildDetailRow(theme, Icons.night_shelter_outlined, 'Nights', '5'),
          _buildDetailRow(theme, Icons.attach_money_outlined, 'Total Payout', '\$1250'),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(theme),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(title, style: theme.textTheme.titleLarge),
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

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () { /* TODO: Reject booking */ },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[700]!),
              ),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () { /* TODO: Approve booking */ },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Approve'),
            ),
          ),
        ],
      ),
    );
  }
}
