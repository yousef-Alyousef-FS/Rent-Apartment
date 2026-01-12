import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/widgets/app_drawer.dart';
import 'package:sakani/screens/main/settings_screen.dart';
import 'package:sakani/models/user.dart';
import 'package:sakani/generated/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                child: user?.profileImageUrl == null ? const Icon(Icons.person) : null,
              ),
            ),
          ),
        ),
        title: Text(loc.homeScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: loc.settingsTooltip,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context, user),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                // --- MODIFIED: Replaced the placeholder with the splash image ---
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Image.asset('assets/images/splash.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, User? user) {
    final loc = AppLocalizations.of(context)!;
    final String name = user?.firstName ?? loc.guest;
    return Text(loc.welcomeBack(name), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}
