import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/booking/edit_booking_screen.dart';
import 'package:plproject/screens/booking/review_screen.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBookings();
    });
  }

  Future<void> _fetchBookings() {
    return Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
  }

  void _showCancelDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<BookingProvider>(context, listen: false).cancelBooking(booking.id);
            },
            child: Text('Yes, Cancel', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(tabs: [Tab(text: 'Upcoming'), Tab(text: 'Completed'), Tab(text: 'Cancelled')]),
        ),
        body: RefreshIndicator(
          onRefresh: _fetchBookings,
          child: Consumer<BookingProvider>(
            builder: (context, provider, child) {
              if (provider.status == BookingStatusState.Loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.status == BookingStatusState.Error) {
                return Center(child: Text(provider.errorMessage ?? 'An error occurred.'));
              }

              final upcoming = provider.bookings.where((b) => b.status == 'confirmed').toList();
              final completed = provider.bookings.where((b) => b.status == 'completed').toList();
              final cancelled = provider.bookings.where((b) => b.status == 'cancelled').toList();

              return TabBarView(
                children: [
                  _buildBookingsList(upcoming, 'You have no upcoming bookings.', 'upcoming'),
                  _buildBookingsList(completed, 'You have no completed bookings.', 'completed'),
                  _buildBookingsList(cancelled, 'You have no cancelled bookings.', null),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String emptyMessage, String? actionsType) {
    if (bookings.isEmpty) {
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.titleMedium));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], actionsType);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, String? actionsType) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    booking.apartment.imageUrls.isNotEmpty ? booking.apartment.imageUrls[0] : '',
                    width: 80, height: 80, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80, height: 80, 
                      color: Colors.grey[200],
                      child: const Icon(Icons.apartment, size: 40, color: Colors.grey)
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.apartment.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Dates: ${booking.checkInDate.toLocal().toString().split(' ')[0]} - ${booking.checkOutDate.toLocal().toString().split(' ')[0]}', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text('Total: \$${booking.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            if (actionsType != null)
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: _buildActionButtons(context, booking, actionsType),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, Booking booking, String actionsType) {
    if (actionsType == 'upcoming') {
      return [
        TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditBookingScreen(booking: booking))), child: const Text('Edit Booking')),
        TextButton(onPressed: () => _showCancelDialog(booking), child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.error))),
      ];
    } else if (actionsType == 'completed') {
      return [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ReviewScreen(apartmentId: booking.apartment.id)));
          },
          child: const Text('Add Review'),
        ),
      ];
    }
    return [];
  }
}
