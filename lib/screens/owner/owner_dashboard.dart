import 'package:flutter/material.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () { /* TODO: Navigate to Owner Profile */ },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Stats Section
          _buildStatsGrid(theme),
          const SizedBox(height: 24),

          // My Apartments Section
          _buildSectionHeader(theme, 'My Apartments', () { /* TODO: Navigate to My Apartments */ }),
          _buildMyApartmentsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () { /* TODO: Navigate to Add Apartment Screen */ },
        label: const Text('Add Apartment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // Important for GridView inside ListView
      physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5, // Adjust aspect ratio for better look
      children: [
        _buildStatCard(theme, 'Total Earnings', '\$12,500', Icons.attach_money, Colors.green),
        _buildStatCard(theme, 'New Bookings', '3', Icons.bookmark_added_outlined, Colors.blue),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        TextButton(onPressed: onViewAll, child: const Text('View All')),
      ],
    );
  }

  Widget _buildMyApartmentsList() {
    // Mock list of owner's apartments
    final myApartments = ['Ocean View Villa', 'Urban Chic Loft'];
    return Column(
      children: myApartments.map((title) => Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          title: Text(title),
          subtitle: const Text('Malibu, California'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () { /* TODO: Navigate to Edit Apartment */ },
        ),
      )).toList(),
    );
  }
}
