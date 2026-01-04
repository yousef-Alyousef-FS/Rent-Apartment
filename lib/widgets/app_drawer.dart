import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';
import 'package:plproject/screens/profile/profile_screen.dart'; // CORRECTED: Navigate to the general profile screen
import 'package:plproject/generated/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Drawer(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user != null ? '${user.firstName} ${user.lastName}' : loc.guest),
                accountEmail: Text(user?.phone ?? loc.notLoggedIn),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                  child: user?.profileImageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(loc.myProfile),
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer
                  // CORRECTED: Navigate to the general ProfileScreen, not the owner-specific one
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(loc.logout),
                onTap: () async {
                  Navigator.of(context).pop(); // Close drawer first
                  await userProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const WelcomeAuthScreen()),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
