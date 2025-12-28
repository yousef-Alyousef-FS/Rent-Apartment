import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Appearance'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode_outlined),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              );
            },
          ),
          
          _buildSectionHeader('Account'),
          ListTile(
            title: const Text('Edit Profile'),
            leading: const Icon(Icons.person_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO */ },
          ),
          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.lock_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () { /* TODO */ },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
