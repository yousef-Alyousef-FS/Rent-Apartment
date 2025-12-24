import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use a consumer to react to changes in UserProvider (like logout)
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            children: [
              _buildProfileHeader(theme as BuildContext, context as ThemeData, user),
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
                // Connect the logout button to the provider method
                onTap: () => _showLogoutDialog(context, userProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog first
                userProvider.logout(); // Then call the logout method
                // AuthGate will handle navigation automatically.
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeData theme, User? user) {
    return InkWell(
      onTap: () { /* TODO: Navigate to Edit Profile */ },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: (user?.profile_image != null)
                  ? NetworkImage(user!.profile_image!)
                  : null,
              child: (user?.profile_image == null)
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null ? '${user.first_name} ${user.last_name}' : 'Guest',
                    style: theme.textTheme.headlineSmall,
                  ),
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
