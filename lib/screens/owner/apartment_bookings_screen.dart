import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/generated/app_localizations.dart';

class ApartmentBookingsScreen extends StatelessWidget {
  final Apartment apartment;

  const ApartmentBookingsScreen({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // Filter the owner's bookings to only show bookings for this specific apartment
    final bookingsForThisApartment = Provider.of<BookingProvider>(context)
        .ownerBookings
        .where((b) => b.apartment.id == apartment.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.bookingsFor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Text(apartment.title, style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ),
      ),
      body: bookingsForThisApartment.isEmpty
          ? Center(
              child: Text(
                loc.noBookingsForApartment,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: bookingsForThisApartment.length,
              itemBuilder: (context, index) {
                return _buildBookingInfoCard(context, bookingsForThisApartment[index], loc);
              },
            ),
    );
  }

  Widget _buildBookingInfoCard(BuildContext context, Booking booking, AppLocalizations loc) {
    final dateFormat = DateFormat('yMMMd', loc.localeName);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: booking.user.profileImageUrl != null
              ? NetworkImage(booking.user.profileImageUrl!)
              : null,
          child: booking.user.profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
        title: Text('${loc.bookedBy} ${booking.user.firstName} ${booking.user.lastName}'),
        subtitle: Text(
            '${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}\n${loc.status}: ${booking.status}'),
        trailing: Text(
          '\$${booking.totalPrice.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        isThreeLine: true,
      ),
    );
  }
}
