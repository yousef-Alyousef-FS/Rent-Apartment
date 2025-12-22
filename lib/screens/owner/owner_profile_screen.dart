import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Profile'),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(theme),
          const SizedBox(height: 24),
          _buildSectionHeader(theme, 'Account Settings'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Personal Info'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO: Navigate to Edit Owner Profile */ },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO: Navigate to Change Password */ },
          ),

          _buildSectionHeader(theme, 'Business Settings'),
           ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Payout Methods'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO: Navigate to Payout Methods */ },
          ),
           ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: const Text('Transaction History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO: Navigate to Transaction History */ },
          ),
          const Divider(),
           ListTile(
            leading: Icon(Icons.logout, color: Colors.red[700]),
            title: Text('Logout', style: TextStyle(color: Colors.red[700])),
            onTap: () { /* TODO: Implement logout */ },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      color: theme.primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            // backgroundImage: NetworkImage('...'), // Placeholder for owner image
            child: Icon(Icons.business_center, size: 50),
          ),
          const SizedBox(height: 16),
          Text('Yasser Otani', style: theme.textTheme.headlineSmall), // Mock Name
          const SizedBox(height: 4),
          Text('Owner since Jan 2024', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
