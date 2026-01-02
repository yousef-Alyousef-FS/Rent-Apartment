import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/welcome_auth_screen.dart';
import 'package:plproject/screens/owner/owner_profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user != null ? '${user.firstName} ${user.lastName}' : 'Guest'),
                accountEmail: Text(user?.phone ?? 'Not logged in'),
                currentAccountPicture: CircleAvatar(
                  // --- CORRECTED: Use profileImageUrl ---
                  backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                  child: user?.profileImageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const OwnerProfileScreen()));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
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
