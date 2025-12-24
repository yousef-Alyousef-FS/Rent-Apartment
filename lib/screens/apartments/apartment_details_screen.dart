import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/booking/booking_success_screen.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final Apartment apartment;
  const ApartmentDetailsScreen({super.key, required this.apartment});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  bool _isBooking = false;

  Future<void> _createBooking() async {
    setState(() {
      _isBooking = true;
    });

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    // Using mock dates for now, as we haven't built a date picker UI yet
    final checkIn = DateTime.now().add(const Duration(days: 10));
    final checkOut = DateTime.now().add(const Duration(days: 17));

    final success = await bookingProvider.createBooking(
      apartmentId: widget.apartment.id,
      checkIn: checkIn,
      checkOut: checkOut,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BookingSuccessScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.errorMessage ?? 'Failed to create booking. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isBooking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.apartment.title),
      ),
      body: ListView(
        children: [
          Image.network(
            widget.apartment.imageUrls.isNotEmpty ? widget.apartment.imageUrls[0] : '',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(height: 250, color: Colors.grey[200]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.apartment.title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(widget.apartment.location, style: theme.textTheme.bodyLarge),
                  ],
                ),
                const Divider(height: 32),
                Text('Details', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailIcon(context, Icons.bed_outlined, '${widget.apartment.bedrooms} Beds'),
                    _buildDetailIcon(context, Icons.bathtub_outlined, '${widget.apartment.bathrooms} Baths'),
                    _buildDetailIcon(context, Icons.area_chart_outlined, '${widget.apartment.area} sqft'),
                  ],
                ),
                const Divider(height: 32),
                Text('Description', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(widget.apartment.description, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBookingBar(theme),
    );
  }

  Widget _buildDetailIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildBookingBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: theme.textTheme.bodyMedium),
              Text('\$${widget.apartment.price.toStringAsFixed(0)} / night', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: _isBooking ? null : _createBooking,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: _isBooking
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
