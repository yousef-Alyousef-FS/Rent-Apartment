import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/auth/welcome_auth_screen.dart';
import 'package:sakani/screens/profile/change_password_screen.dart';
import 'package:sakani/screens/profile/edit_profile_screen.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context, AppLocalizations loc) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                await userProvider.logout();
                if (context.mounted) {
                  Navigator.of(dialogContext).pop(); 
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
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.ownerProfile),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildProfileHeader(theme, user, loc),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, loc.accountSettings),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(loc.editProfile),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(loc.changePassword),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ChangePasswordScreen()));
                  },
                ),
                _buildSectionHeader(theme, loc.businessSettings),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(loc.payoutMethods),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFeatureNotAvailable(context, loc),
                ),
                ListTile(
                  leading: const Icon(Icons.history_toggle_off),
                  title: Text(loc.transactionHistory),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFeatureNotAvailable(context, loc),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red[700]),
                  title: Text(loc.logout, style: TextStyle(color: Colors.red[700])),
                  onTap: () => _showLogoutDialog(context, loc),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, user, AppLocalizations loc) {
    return Container(
      color: theme.primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null,
            child: user.profileImageUrl == null ? const Icon(Icons.business_center, size: 50) : null,
          ),
          const SizedBox(height: 16),
          Text('${user.firstName} ${user.lastName}', style: theme.textTheme.headlineSmall),
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
