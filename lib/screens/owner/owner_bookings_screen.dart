import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/owner/manage_booking_screen.dart';
import 'package:plproject/generated/app_localizations.dart';
import 'package:plproject/screens/booking/booking_detail_screen.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(forceRefresh: true);
    });
  }

  Future<void> _fetchData({bool forceRefresh = false}) {
    return Provider.of<BookingProvider>(context, listen: false).fetchOwnerBookings(forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.apartmentBookings),
          bottom: TabBar(tabs: [Tab(text: loc.newRequests), Tab(text: loc.upcoming), Tab(text: loc.completed)]),
        ),
        body: RefreshIndicator(
          onRefresh: () => _fetchData(forceRefresh: true),
          child: Consumer<BookingProvider>(
            builder: (context, provider, child) {
              if (provider.status == BookingStatusState.Loading && provider.ownerBookings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.status == BookingStatusState.Error && provider.ownerBookings.isEmpty) {
                return Center(child: Text(loc.errorOccurred(provider.errorMessage ?? '...')));
              }

              final newRequests = provider.ownerBookings.where((b) => b.status == 'pending_approval').toList();
              final upcoming = provider.ownerBookings.where((b) => b.status == 'confirmed').toList();
              final completed = provider.ownerBookings.where((b) => b.status == 'completed').toList();

              return TabBarView(
                children: [
                  _buildBookingsList(context, newRequests, loc.noNewRequests, isRequest: true),
                  _buildBookingsList(context, upcoming, loc.noUpcomingBookings),
                  _buildBookingsList(context, completed, loc.noCompletedBookings),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, List<Booking> bookings, String emptyMessage, {bool isRequest = false}) {
    if (bookings.isEmpty) {
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(context, bookings[index], isRequest);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking, bool isRequest) {
    final loc = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yMd', loc.localeName);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: booking.user.profileImageUrl != null ? NetworkImage(booking.user.profileImageUrl!) : null,
          child: booking.user.profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text('${booking.user.firstName} ${booking.user.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${booking.apartment.title}\n${loc.dates}: ${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}'),
        trailing: isRequest ? const Icon(Icons.chevron_right) : null,
        isThreeLine: true,
        // --- UPDATED: All cards are now tappable ---
        onTap: () {
          if (isRequest) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageBookingScreen(booking: booking)));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingDetailScreen(booking: booking)));
          }
        },
      ),
    );
  }
}
