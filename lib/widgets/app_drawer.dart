import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/profile/edit_profile_screen.dart';
import 'package:plproject/widgets/menu_list_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          final String? imageUrl = user?.profile_image;

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  user != null ? '${user.first_name ?? ''} ${user.last_name ?? ''}'.trim() : 'Welcome',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: Text(user?.phone ?? 'Login or Register'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                  child: imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 40, color: Colors.white);
                            },
                          ),
                        )
                      : const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              // Simplified to only include essential user-related actions
              MenuListItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.of(context).pop(); // Close drawer first
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
                },
              ),
              const Divider(),
              if (userProvider.isLoggedIn)
                MenuListItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: Colors.red[700],
                  onTap: () {
                    Navigator.of(context).pop();
                    userProvider.logout();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
