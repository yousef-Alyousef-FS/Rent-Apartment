import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';

class ManageBookingScreen extends StatefulWidget {
  final Booking booking;
  const ManageBookingScreen({super.key, required this.booking});

  @override
  State<ManageBookingScreen> createState() => _ManageBookingScreenState();
}

class _ManageBookingScreenState extends State<ManageBookingScreen> {
  bool _isLoading = false;

  Future<void> _approve() async {
    setState(() { _isLoading = true; });
    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.approveBooking(widget.booking.id);
    if (mounted && success) {
      Navigator.of(context).pop();
    }
    // TODO: Handle error state
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _reject() async {
    setState(() { _isLoading = true; });
    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.rejectBooking(widget.booking.id);
    if (mounted && success) {
      Navigator.of(context).pop();
    }
    // TODO: Handle error state
     if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booking = widget.booking;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Booking Request'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Renter Information
          _buildSectionHeader(theme, 'Renter Information'),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: booking.user.profile_image != null ? NetworkImage(booking.user.profile_image!) : null,
                child: booking.user.profile_image == null ? const Icon(Icons.person) : null,
              ),
              title: Text('${booking.user.first_name} ${booking.user.last_name}'),
              subtitle: const Text('Joined: Jan 2024'), // Mock data
            ),
          ),
          const SizedBox(height: 24),

          // Booking Details
          _buildSectionHeader(theme, 'Booking Details'),
          _buildDetailRow(theme, Icons.apartment_outlined, 'Apartment', booking.apartment.title),
          _buildDetailRow(theme, Icons.calendar_today_outlined, 'Dates', '${booking.checkInDate.toLocal().toString().split(' ')[0]} - ${booking.checkOutDate.toLocal().toString().split(' ')[0]}'),
          _buildDetailRow(theme, Icons.night_shelter_outlined, 'Nights', booking.checkOutDate.difference(booking.checkInDate).inDays.toString()),
          _buildDetailRow(theme, Icons.attach_money_outlined, 'Total Payout', '\$${booking.totalPrice.toStringAsFixed(2)}'),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(theme),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

   Widget _buildDetailRow(ThemeData theme, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : _reject,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[700]!),
              ),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _approve,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Approve'),
            ),
          ),
        ],
      ),
    );
  }
}
