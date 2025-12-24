import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';

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
      // Use listen: false inside initState
      Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            if (provider.status == BookingStatusState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.status == BookingStatusState.Error) {
              return Center(child: Text('Error: ${provider.errorMessage}'));
            }
            if (provider.status == BookingStatusState.Loaded) {
              // Filter the bookings based on their status
              final upcoming = provider.bookings.where((b) => b.status == 'confirmed').toList();
              final completed = provider.bookings.where((b) => b.status == 'completed').toList();
              final cancelled = provider.bookings.where((b) => b.status == 'cancelled').toList();

              return TabBarView(
                children: [
                  _buildBookingsList(upcoming, 'You have no upcoming bookings.'),
                  _buildBookingsList(completed, 'You have no completed bookings.'),
                  _buildBookingsList(cancelled, 'You have no cancelled bookings.'),
                ],
              );
            }
            return const Center(child: Text('Pull to refresh or login again.'));
          },
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String emptyMessage) {
    if (bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(emptyMessage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
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
                  Text('Total: \$${booking.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
