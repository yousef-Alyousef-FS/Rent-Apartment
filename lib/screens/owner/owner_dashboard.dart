import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/apartments/apartment_details_screen.dart';
import 'package:plproject/screens/owner/add_apartment_screen.dart';
import 'package:plproject/screens/owner/owner_bookings_screen.dart';
import 'package:plproject/screens/owner/my_apartments_screen.dart';

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
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    // Use Future.wait to run fetches in parallel for efficiency
    await Future.wait([
      Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments(),
      Provider.of<BookingProvider>(context, listen: false).fetchOwnerDashboardStats(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Dashboard')),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('Welcome, Owner!', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
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
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddApartmentScreen())),
        label: const Text('Add Apartment'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.7,
          children: [
            InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const OwnerBookingsScreen())),
                child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(bookingProvider.newBookingsCount.toString(), style: theme.textTheme.headlineSmall), const Text('New Bookings')])))),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('\$${bookingProvider.totalEarnings.toStringAsFixed(0)}', style: theme.textTheme.headlineSmall), const Text('Total Earnings')]))),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        TextButton(onPressed: onViewAll, child: const Text('View All')),
      ],
    );
  }

  Widget _buildMyApartmentsList() {
    return Consumer<ApartmentProvider>(
      builder: (context, provider, child) {
        if (provider.status == ApartmentStatus.Loading) {
          return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator()));
        }
        if (provider.status == ApartmentStatus.Error) {
          return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 32), child: Text(provider.errorMessage ?? 'Could not load your apartments.')));
        }
        if (provider.myApartments.isEmpty) {
          return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Text('You have not added any apartments yet.')));
        }
        return Column(
          children: provider.myApartments.take(3).map((apartment) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(apartment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              // --- UPDATED: Subtitle now uses new fields ---
              subtitle: Text('${apartment.rooms ?? 0} rooms in ${apartment.city ?? 'N/A'}'), 
              trailing: Text('\$${apartment.price}/night', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ApartmentDetailsScreen(apartment: apartment, isOwnerView: true),
              )),
            ),
          )).toList(),
        );
      },
    );
  }
}
