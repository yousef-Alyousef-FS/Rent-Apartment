import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/widgets/app_drawer.dart';
import 'package:plproject/widgets/featured_apartment_card.dart'; // Use the new card
import 'package:plproject/widgets/section_header.dart';
import 'package:plproject/screens/main/search_screen.dart';
import 'package:plproject/screens/main/settings_screen.dart';

import '../../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

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
                child: user?.profile_image != null
                    ? ClipOval(child: Image.network(user!.profile_image!, fit: BoxFit.cover, width: 40, height: 40, errorBuilder: (c, e, s) => const Icon(Icons.person)))
                    : const Icon(Icons.person),
              ),
            ),
          ),
        ),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            _buildWelcomeHeader(context, user),
            const SizedBox(height: 24),
            SectionHeader(title: 'Featured', onViewAll: () { /* TODO */ }),
            _buildFeaturedList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, User? user) {
    final String name = user?.first_name ?? 'Guest';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text('Welcome back, $name!', style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Widget _buildFeaturedList(BuildContext context) {
    return Consumer<ApartmentProvider>(
      builder: (context, provider, child) {
        if (provider.status == ApartmentStatus.Loading && provider.apartments.isEmpty) {
          return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
        }

        if (provider.status == ApartmentStatus.Error) {
            return SizedBox(height: 220, child: Center(child: Text(provider.errorMessage ?? 'Could not load apartments.')));
        }

        final apartments = provider.apartments.isNotEmpty 
            ? provider.apartments
            : [
                Apartment(id: 99, title: '(Mock) Beachside Villa', description: '...', price: 250, location: 'Malibu, CA', bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250.png/00897b/FFFFFF?text=Villa']),
                Apartment(id: 98, title: '(Mock) Downtown Loft', description: '...', price: 180, location: 'New York, NY', bedrooms: 2, bathrooms: 2, area: 150, imageUrls: ['https://via.placeholder.com/400x250.png/ffc107/000000?text=Loft']),
              ];

        return SizedBox(
          height: 210, // Adjusted height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16, right: 8),
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200, // Adjusted width
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FeaturedApartmentCard(apartment: apartments[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
