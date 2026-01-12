import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/booking.dart';
import 'package:sakani/providers/booking_provider.dart';
import 'package:sakani/generated/app_localizations.dart';

class ManageBookingScreen extends StatefulWidget {
  final Booking booking;
  const ManageBookingScreen({super.key, required this.booking});

  @override
  State<ManageBookingScreen> createState() => _ManageBookingScreenState();
}

class _ManageBookingScreenState extends State<ManageBookingScreen> {
  bool _isApproving = false;
  bool _isRejecting = false;

  Future<void> _approve() async {
    setState(() => _isApproving = true);
    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.approveBooking(widget.booking.id);
    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? AppLocalizations.of(context)!.actionFailed),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      setState(() => _isApproving = false);
    }
  }

  Future<void> _reject() async {
    setState(() => _isRejecting = true);
    final provider = Provider.of<BookingProvider>(context, listen: false);
    final success = await provider.rejectBooking(widget.booking.id);
    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? AppLocalizations.of(context)!.actionFailed),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      setState(() => _isRejecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booking = widget.booking;
    final loc = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yMd', loc.localeName);
    
    final userFullName = '${booking.user?.firstName ?? ''} ${booking.user?.lastName ?? ''}';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.manageBookingRequest),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(theme, loc.renterInformation),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: booking.user?.profileImageUrl != null ? NetworkImage(booking.user!.profileImageUrl!) : null,
                child: booking.user?.profileImageUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(userFullName.trim().isNotEmpty ? userFullName.trim() : 'Unknown User'),
              subtitle: Text(booking.user?.phone ?? 'No phone number'),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(theme, loc.bookingDetails),
          _buildDetailRow(theme, Icons.apartment_outlined, loc.apartment, booking.apartment?.title ?? loc.bookingDetailsUnavailable),
          _buildDetailRow(theme, Icons.calendar_today_outlined, loc.dates, '${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}'),
          _buildDetailRow(theme, Icons.night_shelter_outlined, loc.nights(booking.checkOutDate.difference(booking.checkInDate).inDays), booking.checkOutDate.difference(booking.checkInDate).inDays.toString()),
          _buildDetailRow(theme, Icons.attach_money_outlined, loc.totalPayout, '\$${booking.totalPrice.toStringAsFixed(2)}'),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(theme, loc),
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

  Widget _buildActionButtons(ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isApproving || _isRejecting ? null : _reject,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 50),
                foregroundColor: Colors.red[700],
                side: BorderSide(color: Colors.red[700]!),
              ),
              child: _isRejecting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                  : Text(loc.reject),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isApproving || _isRejecting ? null : _approve,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: _isApproving
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                  : Text(loc.approve),
            ),
          ),
        ],
      ),
    );
  }
}
