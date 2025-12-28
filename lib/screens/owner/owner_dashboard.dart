import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/screens/owner/add_apartment_screen.dart';
import 'package:plproject/screens/owner/edit_apartment_screen.dart';
import 'package:plproject/screens/owner/my_apartments_screen.dart';
import 'package:plproject/screens/owner/owner_bookings_screen.dart';
import 'package:plproject/screens/owner/owner_profile_screen.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments();
    });
  }

  List<Apartment> _getMockApartments() {
    return [
      Apartment(id: 101, title: 'My First Apartment', description: 'Mock description', location: 'City Center', price: 120, bedrooms: 2, bathrooms: 1, area: 90, imageUrls: []),
      Apartment(id: 102, title: 'My Second Apartment', description: 'Mock description', location: 'Suburb Area', price: 95, bedrooms: 3, bathrooms: 2, area: 120, imageUrls: []),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const OwnerProfileScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildStatsGrid(theme),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'My Apartments', () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyApartmentsScreen()));
            }),
            _buildMyApartmentsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddApartmentScreen()));
        },
        label: const Text('Add Apartment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('\$12,500', style: theme.textTheme.headlineSmall), Text('Total Earnings')]),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const OwnerBookingsScreen()));
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('3', style: theme.textTheme.headlineSmall), Text('New Bookings')]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        TextButton(onPressed: onViewAll, child: const Text('View All')),
      ],
    );
  }

  Widget _buildMyApartmentsList() {
    return Consumer<ApartmentProvider>(
      builder: (context, provider, child) {
        if (provider.status == ApartmentStatus.Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        final apartments = provider.myApartments.isEmpty ? _getMockApartments() : provider.myApartments;
        final previewApartments = apartments.take(3).toList();

        return Column(
          children: previewApartments.map((apartment) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(apartment.title),
              subtitle: Text(apartment.location),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditApartmentScreen(apartment: apartment)));
              },
            ),
          )).toList(),
        );
      },
    );
  }
}
