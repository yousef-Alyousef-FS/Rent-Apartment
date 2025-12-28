import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/booking/edit_booking_screen.dart';
import 'package:plproject/screens/booking/review_screen.dart';
import 'package:plproject/widgets/app_drawer.dart';

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
      Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
    });
  }

  List<Booking> _getMockBookings() {
    final mockApartment = Apartment(id: 99, title: 'Mock Apartment for Testing', description: 'Mock description', price: 100, location: 'Mock Location', bedrooms: 2, bathrooms: 1, area: 80, imageUrls: []);
    final mockUser = User(id: 1, first_name: 'Mock', last_name: 'User', phone: '123');
    return [
      Booking(id: 1, apartment: mockApartment, user: mockUser, checkInDate: DateTime.now().add(const Duration(days: 5)), checkOutDate: DateTime.now().add(const Duration(days: 10)), totalPrice: 500, status: 'confirmed'),
      Booking(id: 2, apartment: mockApartment, user: mockUser, checkInDate: DateTime.now().subtract(const Duration(days: 10)), checkOutDate: DateTime.now().subtract(const Duration(days: 5)), totalPrice: 500, status: 'completed'),
      Booking(id: 3, apartment: mockApartment, user: mockUser, checkInDate: DateTime.now().subtract(const Duration(days: 20)), checkOutDate: DateTime.now().subtract(const Duration(days: 15)), totalPrice: 500, status: 'cancelled'),
    ];
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
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
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
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(tabs: [Tab(text: 'Upcoming'), Tab(text: 'Completed'), Tab(text: 'Cancelled')]),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            if (provider.status == BookingStatusState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final allBookings = provider.bookings.isEmpty ? _getMockBookings() : provider.bookings;
            final upcoming = allBookings.where((b) => b.status == 'confirmed').toList();
            final completed = allBookings.where((b) => b.status == 'completed').toList();
            final cancelled = allBookings.where((b) => b.status == 'cancelled').toList();

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
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String emptyMessage, String? actionsType) {
    if (bookings.isEmpty) {
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.titleMedium));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], actionsType);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, String? actionsType) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Padding(
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
          if (actionsType != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ButtonBar(
                alignment: MainAxisAlignment.end,
                children: _buildActionButtons(context, booking, actionsType),
              ),
            )
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, Booking booking, String actionsType) {
    if (actionsType == 'upcoming') {
      return [
        TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditBookingScreen(booking: booking))), child: const Text('Edit Booking')),
        TextButton(onPressed: () => _showCancelDialog(booking), child: const Text('Cancel Booking', style: TextStyle(color: Colors.red))),
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
