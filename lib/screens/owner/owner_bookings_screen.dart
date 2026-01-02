import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/owner/manage_booking_screen.dart';

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
      _fetchData();
    });
  }

  Future<void> _fetchData() {
    // --- CORRECTED: Called the correct fetch method --- 
    return Provider.of<BookingProvider>(context, listen: false).fetchBookingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Apartment Bookings'),
          bottom: const TabBar(tabs: [Tab(text: 'New Requests'), Tab(text: 'Upcoming'), Tab(text: 'Completed')]),
        ),
        body: RefreshIndicator(
          onRefresh: _fetchData,
          child: Consumer<BookingProvider>(
            builder: (context, provider, child) {
              if (provider.status == BookingStatusState.Loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.status == BookingStatusState.Error) {
                return Center(child: Text(provider.errorMessage ?? 'An error occurred.'));
              }

              final newRequests = provider.bookings.where((b) => b.status == 'pending_approval').toList();
              final upcoming = provider.bookings.where((b) => b.status == 'confirmed').toList();
              final completed = provider.bookings.where((b) => b.status == 'completed').toList();

              return TabBarView(
                children: [
                  _buildBookingsList(context, newRequests, 'No new booking requests.', isRequest: true),
                  _buildBookingsList(context, upcoming, 'No upcoming bookings.'),
                  _buildBookingsList(context, completed, 'No completed bookings.'),
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
        subtitle: Text('${booking.apartment.title}\nDates: ${booking.checkInDate.toLocal().toString().split(' ')[0]} - ${booking.checkOutDate.toLocal().toString().split(' ')[0]}'),
        trailing: isRequest ? const Icon(Icons.chevron_right) : null,
        isThreeLine: true,
        onTap: () {
          if (isRequest) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageBookingScreen(booking: booking)));
          }
        },
      ),
    );
  }
}
