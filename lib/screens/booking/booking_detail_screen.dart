import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/generated/app_localizations.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isCancelling = false;

  Future<void> _getDirections(BuildContext context, Apartment apartment) async {
    final loc = AppLocalizations.of(context)!;
    final address = '${apartment.address ?? ''}, ${apartment.city ?? ''}, ${apartment.governorate ?? ''}';

    if (address.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.directionsNotAvailable)),
      );
      return;
    }

    final query = Uri.encodeComponent(address);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch maps')),
      );
    }
  }

  void _showCancelConfirmationDialog(BuildContext context, Booking booking) {
    final loc = AppLocalizations.of(context)!;
    final provider = Provider.of<BookingProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.confirmCancellation),
          content: Text(loc.areYouSureCancelBooking),
          actions: <Widget>[
            TextButton(
              child: Text(loc.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(loc.cancelBooking, style: const TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                setState(() => _isCancelling = true);

                final success = await provider.cancelBooking(booking.id);

                if (!mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.cancellationSuccess), backgroundColor: Colors.green),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage ?? loc.cancellationError), backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }

                if (mounted) {
                  setState(() => _isCancelling = false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM d, yyyy');
    final booking = widget.booking;
    final checkInDate = booking.checkInDate;
    final checkOutDate = booking.checkOutDate;
    final numberOfNights = checkOutDate.difference(checkInDate).inDays;
    final serviceFee = 50.0;
    final pricePerNight = (numberOfNights > 0) ? (booking.totalPrice / numberOfNights) : 0;
    final totalPaid = booking.totalPrice + serviceFee;

    return Scaffold(
      appBar: AppBar(title: Text(loc.bookingDetails)),
      body: ListView(
        children: [
          Image.network(
            booking.apartment.imageUrls.isNotEmpty ? booking.apartment.imageUrls[0] : '',
            height: 200, fit: BoxFit.cover,
            errorBuilder: (ctx, err, st) => Container(height: 200, color: Colors.grey[300], child: const Center(child: Icon(Icons.apartment, size: 80, color: Colors.grey))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.apartment.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                if (booking.apartment.city != null && booking.apartment.governorate != null)
                  Text('${booking.apartment.city}, ${booking.apartment.governorate}', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                const Divider(height: 32),

                _buildDetailRow(theme, Icons.calendar_today_outlined, loc.dates, '${dateFormat.format(checkInDate)} - ${dateFormat.format(checkOutDate)}'),
                _buildDetailRow(theme, Icons.night_shelter_outlined, loc.nights(numberOfNights), numberOfNights.toString()),
                _buildDetailRow(theme, Icons.people_outline, loc.guests, '1'),
                const Divider(height: 32),

                Text(loc.priceDetails, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                _buildCostRow(theme, '\$${pricePerNight.toStringAsFixed(0)} x ${loc.nights(numberOfNights)}', '\$${booking.totalPrice.toStringAsFixed(0)}'),
                _buildCostRow(theme, loc.serviceFee, '\$${serviceFee.toStringAsFixed(0)}'),
                const Divider(),
                _buildCostRow(theme, loc.totalPaid, '\$${totalPaid.toStringAsFixed(0)}', isTotal: true),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.directions),
                        label: Text(loc.getDirections),
                        onPressed: () => _getDirections(context, booking.apartment),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: _isCancelling ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.cancel_outlined),
                        label: Text(loc.cancelBooking),
                        onPressed: _isCancelling ? null : () => _showCancelConfirmationDialog(context, booking),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildCostRow(ThemeData theme, String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) : theme.textTheme.bodyLarge),
          Text(amount, style: isTotal ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) : theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}