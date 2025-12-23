import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(theme, context),
          const SizedBox(height: 24),
          _buildProfileMenuItem(
            context,
            icon: Icons.bookmark_border,
            title: 'My Bookings',
            onTap: () { /* TODO: Navigate to Bookings List */ },
          ),
           _buildProfileMenuItem(
            context,
            icon: Icons.favorite_border,
            title: 'Favorites',
            onTap: () { /* TODO: Navigate to Favorites Screen */ },
          ),
          _buildProfileMenuItem(
            context,
            icon: Icons.reviews_outlined,
            title: 'My Reviews',
            onTap: () { /* TODO: Navigate to My Reviews Screen */ },
          ),
           _buildProfileMenuItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () { /* TODO: Navigate to Settings Screen */ },
          ),
          const Divider(height: 32),
          _buildProfileMenuItem(
            context,
            icon: Icons.logout,
            title: 'Logout',
            color: Colors.red[700],
            onTap: () { /* TODO: Implement logout */ },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, BuildContext context) {
    return InkWell(
      onTap: () { /* TODO: Navigate to Edit Profile */ },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              // backgroundImage: NetworkImage('...'), // Placeholder
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yasser Otani', style: theme.textTheme.headlineSmall), // Mock Name
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('View and edit profile', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[600]),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: (onTap != null) ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
