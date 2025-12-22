import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

class BookingsListScreen extends StatelessWidget {
  const BookingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(BookingStatus.upcoming),
            _buildBookingsList(BookingStatus.completed),
            _buildBookingsList(BookingStatus.cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(BookingStatus status) {
    // Mock data for display
    final mockBookings = {
      BookingStatus.upcoming: [
        Apartment(id: 1, title: 'Ocean View Villa', price: 1750, location: 'Malibu, CA', bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250/FF5722/FFFFFF?Text=Villa'], description: ''),
      ],
      BookingStatus.completed: [
        Apartment(id: 2, title: 'Urban Chic Loft', price: 1500, location: 'SoHo, NY', bedrooms: 2, bathrooms: 2, area: 150, imageUrls: ['https://via.placeholder.com/400x250/4CAF50/FFFFFF?Text=Loft'], description: ''),
      ],
      BookingStatus.cancelled: [],
    };

    final bookings = mockBookings[status]!;

    if (bookings.isEmpty) {
      return Center(child: Text('No ${status.name} bookings.'));
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(Apartment apartment) {
    // A simplified card for the booking list
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(apartment.imageUrls[0], width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(apartment.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Dates: Sep 20 - Sep 27', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Total: \$${apartment.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum BookingStatus { upcoming, completed, cancelled }
