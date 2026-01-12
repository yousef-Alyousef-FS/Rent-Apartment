import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/providers/theme_provider.dart';
import 'package:sakani/providers/locale_provider.dart';
// --- CORRECTEDsakani true, standard path ---
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/profile/edit_profile_screen.dart';
import 'package:sakani/screens/profile/change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(loc.appearance),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title: Text(loc.darkMode),
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
          _buildSectionHeader(loc.language),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              String currentLanguage = 'en';
              if (localeProvider.locale?.languageCode == 'ar') {
                currentLanguage = 'ar';
              }

              return ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(loc.appLanguage),
                trailing: DropdownButton<String>(
                  value: currentLanguage,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      localeProvider.setLocale(Locale(newValue));
                    }
                  },
                ),
              );
            },
          ),
          _buildSectionHeader(loc.account),
          ListTile(
            title: Text(loc.editProfile),
            leading: const Icon(Icons.person_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditProfileScreen()));
            },
          ),
          ListTile(
            title: Text(loc.changePassword),
            leading: const Icon(Icons.lock_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ChangePasswordScreen()));
            },
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
