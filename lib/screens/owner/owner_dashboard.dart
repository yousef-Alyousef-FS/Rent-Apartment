import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/generated/app_localizations.dart';
import 'package:plproject/screens/apartments/apartment_details_screen.dart';
import 'package:plproject/screens/owner/add_apartment_screen.dart';
import 'package:plproject/screens/owner/owner_bookings_screen.dart';
import 'package:plproject/screens/owner/my_apartments_screen.dart';
import 'package:plproject/screens/owner/manage_booking_screen.dart';

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
    await Future.wait([
      Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments(),
      Provider.of<BookingProvider>(context, listen: false).fetchOwnerBookings(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.ownerDashboard)),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(loc.welcomeOwner, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, loc.newRequests, () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const OwnerBookingsScreen()));
            }),
            _buildNewBookingsList(loc),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, loc.myApartments, () { // Corrected Title
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MyApartmentsScreen()));
            }),
            _buildMyApartmentsList(loc),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddApartmentScreen())),
        label: Text(loc.addApartment),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, VoidCallback onViewAll) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        TextButton(onPressed: onViewAll, child: Text(loc.viewAll)),
      ],
    );
  }

  Widget _buildNewBookingsList(AppLocalizations loc) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final newRequests = provider.ownerBookings.where((b) => b.status == 'pending_approval').take(3).toList();

        if (newRequests.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(loc.noNewRequests, style: TextStyle(color: Colors.grey[600])),
            ),
          );
        }
        return Column(
          children: newRequests.map((booking) => _buildBookingRequestCard(context, booking, loc)).toList(),
        );
      },
    );
  }

  Widget _buildBookingRequestCard(BuildContext context, Booking booking, AppLocalizations loc) {
    final dateFormat = DateFormat('yMd', loc.localeName); // Correctly localized date format
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: booking.user.profileImageUrl != null ? NetworkImage(booking.user.profileImageUrl!) : null,
          child: booking.user.profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text('${booking.user.firstName} ${booking.user.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${booking.apartment.title}\n${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => ManageBookingScreen(booking: booking),
        )),
      ),
    );
  }

  Widget _buildMyApartmentsList(AppLocalizations loc) {
    return Consumer<ApartmentProvider>(
      builder: (context, provider, child) {
        if (provider.status == ApartmentStatus.Loading && provider.myApartments.isEmpty) {
          return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator()));
        }
        if (provider.status == ApartmentStatus.Error) {
          return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 32), child: Text(provider.errorMessage ?? loc.couldNotLoadApartments)));
        }
        if (provider.myApartments.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(loc.noApartmentsAdded, style: TextStyle(color: Colors.grey[600])),
            ),
          );
        }
        return Column(
          children: provider.myApartments.take(3).map((apartment) => Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(apartment.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${loc.rooms(apartment.rooms ?? 0)} in ${apartment.city ?? 'N/A'}'),
              trailing: Text('\$${apartment.price}${loc.perNight}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
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
