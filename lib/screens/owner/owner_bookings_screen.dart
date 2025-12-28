import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/models/user.dart';
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
      Provider.of<BookingProvider>(context, listen: false).fetchBookingRequests();
    });
  }

  List<Booking> _getMockRequests() {
    final mockApartment = Apartment(id: 101, title: 'My First Mock Apartment', description: 'Mock description', location: 'City Center', price: 120, bedrooms: 2, bathrooms: 1, area: 90, imageUrls: []);
    final mockUser = User(id: 201, first_name: 'Jane', last_name: 'Doe', phone: '+987654321');
    return [
      Booking(id: 1, apartment: mockApartment, user: mockUser, checkInDate: DateTime.now().add(const Duration(days: 2)), checkOutDate: DateTime.now().add(const Duration(days: 7)), totalPrice: 600, status: 'pending_approval'),
      Booking(id: 2, apartment: mockApartment, user: mockUser, checkInDate: DateTime.now().add(const Duration(days: 10)), checkOutDate: DateTime.now().add(const Duration(days: 15)), totalPrice: 600, status: 'pending_approval'),
    ];
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
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            if (provider.status == BookingStatusState.Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.status == BookingStatusState.Error) {
              return Center(child: Text('Error: ${provider.errorMessage}'));
            }

            final requests = provider.bookingRequests.isEmpty ? _getMockRequests() : provider.bookingRequests;

            return TabBarView(
              children: [
                _buildRequestsList(context, requests),
                _buildBookingsList(context, [], 'upcoming'),
                _buildBookingsList(context, [], 'completed'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, List<Booking> requests) {
    if (requests.isEmpty) {
      return const Center(child: Text('No new booking requests.'));
    }
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(context, requests[index]);
      },
    );
  }

  Widget _buildBookingsList(BuildContext context, List<Booking> bookings, String status) {
    return Center(child: Text('No $status bookings yet.'));
  }

  Widget _buildRequestCard(BuildContext context, Booking booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: booking.user.profile_image != null ? NetworkImage(booking.user.profile_image!) : null,
          child: booking.user.profile_image == null ? const Icon(Icons.person) : null,
        ),
        title: Text('${booking.user.first_name} ${booking.user.last_name}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${booking.apartment.title}\nDates: ${booking.checkInDate.toLocal().toString().split(' ')[0]} - ${booking.checkOutDate.toLocal().toString().split(' ')[0]}'),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageBookingScreen(booking: booking)));
        },
      ),
    );
  }
}
