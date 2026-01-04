import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/main/settings_screen.dart';
// --- CORRECTED: Use the correct screen we already built ---
import 'package:plproject/screens/booking/bookings_list_screen.dart'; 
import 'package:plproject/screens/profile/my_reviews_screen.dart';
import 'package:plproject/screens/profile/edit_profile_screen.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';
import 'package:plproject/widgets/menu_list_item.dart'; 
import 'package:plproject/generated/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, UserProvider userProvider, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmLogout),
          content: Text(loc.areYouSureLogout),
          actions: <Widget>[
            TextButton(
              child: Text(loc.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(loc.logout, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); 
                await userProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showFeatureNotAvailable(BuildContext context, AppLocalizations loc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.featureNotAvailable)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myProfile),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(context, user, loc),
          const SizedBox(height: 24),
          MenuListItem(
            icon: Icons.bookmark_border,
            title: loc.myBookings,
            onTap: () {
              // --- CORRECTED: Navigate to the correct screen ---
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const BookingsListScreen()));
            },
          ),
          MenuListItem(
            icon: Icons.favorite_border,
            title: loc.favorites,
            onTap: () => _showFeatureNotAvailable(context, loc),
          ),
          MenuListItem(
            icon: Icons.reviews_outlined,
            title: loc.myReviews,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyReviewsScreen()));
            },
          ),
          MenuListItem(
            icon: Icons.settings_outlined,
            title: loc.settings,
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
          ),
          const Divider(height: 32),
          if (userProvider.isLoggedIn)
            MenuListItem(
              icon: Icons.logout,
              title: loc.logout,
              color: Colors.red[700],
              onTap: () => _showLogoutDialog(context, userProvider, loc),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? user, AppLocalizations loc) {
    final theme = Theme.of(context);
    final String displayName = user?.firstName != null
        ? '${user!.firstName} ${user.lastName ?? ''}'.trim()
        : loc.guest;
    final String? imageUrl = user?.profileImageUrl;

    return InkWell(
      onTap: () {
        if (user != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
        }
      },
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
                        Text(loc.viewAndEditProfile, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
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
}
