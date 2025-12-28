import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/main/settings_screen.dart';
import 'package:plproject/widgets/menu_list_item.dart'; // Import the new widget

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
          ),
          body: ListView(
            children: [
              _buildProfileHeader(context, user),
              const SizedBox(height: 24),
              MenuListItem(
                icon: Icons.bookmark_border,
                title: 'My Bookings',
                onTap: () { /* TODO */ },
              ),
              MenuListItem(
                icon: Icons.favorite_border,
                title: 'Favorites',
                onTap: () { /* TODO */ },
              ),
              MenuListItem(
                icon: Icons.reviews_outlined,
                title: 'My Reviews',
                onTap: () { /* TODO */ },
              ),
              MenuListItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
                },
              ),
              const Divider(height: 32),
              if (userProvider.isLoggedIn)
                MenuListItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: Colors.red[700],
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
                Navigator.of(dialogContext).pop();
                userProvider.logout();
              },
            ),
          ],
        );
      },
    );
  }

  // This widget remains local as it's unique to this screen
  Widget _buildProfileHeader(BuildContext context, User? user) {
    final theme = Theme.of(context);
    final String displayName = user?.first_name != null
        ? '${user!.first_name} ${user.last_name ?? ''}'.trim()
        : 'Guest';
    final String? imageUrl = user?.profile_image;

    return InkWell(
      onTap: () { /* TODO: Navigate to Edit Profile only if logged in */ },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null 
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: theme.textTheme.headlineSmall),
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('View and edit profile', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[600]),
                      ],
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // _buildProfileMenuItem has been removed
}
