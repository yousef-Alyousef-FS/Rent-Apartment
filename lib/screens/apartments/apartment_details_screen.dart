import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/screens/booking/booking_screen.dart'; // UPDATED
import 'package:plproject/screens/owner/edit_apartment_screen.dart';

class ApartmentDetailsScreen extends StatefulWidget {
  final Apartment apartment;
  final bool isOwnerView;

  const ApartmentDetailsScreen({
    super.key,
    required this.apartment,
    this.isOwnerView = false,
  });

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {

  void _navigateToBooking() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BookingScreen(apartment: widget.apartment),
    ));
  }

  void _navigateToEdit() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditApartmentScreen(apartment: widget.apartment),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apartment = widget.apartment;

    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.title),
        actions: [
          if (widget.isOwnerView)
            IconButton(icon: const Icon(Icons.edit_outlined),
                onPressed: _navigateToEdit)
        ],
      ),
      body: ListView(
        children: [
          _buildImageCarousel(context, apartment.imageUrls),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apartment.title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                _buildRatingSection(theme, apartment),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.grey[600],
                        size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${apartment.city ?? ''}, ${apartment.governorate ??
                            ''}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Text('Details', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailIcon(context, Icons.bed_outlined,
                        '${apartment.rooms ?? 0} Rooms'),
                    _buildDetailIcon(context, Icons.area_chart_outlined,
                        '${apartment.area ?? 0} sqm'),
                  ],
                ),
                const Divider(height: 32),
                Text('Description', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(apartment.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isOwnerView
          ? _buildOwnerActionsBar(theme)
          : _buildBookingBar(theme),
    );
  }

  Widget _buildOwnerActionsBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Edit Apartment Details'),
        onPressed: _navigateToEdit,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16)),
      ),
    );
  }

  Widget _buildBookingBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Theme
          .of(context)
          .scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ],
          border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price'),
                Text('\$${widget.apartment.price.toStringAsFixed(0)} / night',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold))
              ]),
          ElevatedButton(
            onPressed: _navigateToBooking,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(
                horizontal: 40, vertical: 16)),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container(height: 250,
          color: Colors.grey[200],
          child: const Center(
              child: Icon(Icons.apartment, size: 80, color: Colors.grey)));
    }
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) =>
            Image.network(imageUrls[index], fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(color: Colors.grey[200],
                        child: const Center(
                            child: Icon(Icons.error_outline, size: 80)))),
      ),
    );
  }

  Widget _buildRatingSection(ThemeData theme, Apartment apartment) {
    final rating = apartment.average_rating ?? 0.0;
    final reviewCount = apartment.reviews_count ?? 0;
    if (reviewCount == 0) return const SizedBox
        .shrink(); // Don't show rating if there are no reviews

    List<Widget> stars = List.generate(5, (index) {
      double starValue = rating - index;
      if (starValue >= 1.0)
        return const Icon(Icons.star, color: Colors.amber, size: 20);
      if (starValue >= 0.5)
        return const Icon(Icons.star_half, color: Colors.amber, size: 20);
      return const Icon(Icons.star_border, color: Colors.amber, size: 20);
    });

    return Row(children: [
      ...stars,
      const SizedBox(width: 8),
      Text('$rating ($reviewCount reviews)')
    ]);
  }

  Widget _buildDetailIcon(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme
            .of(context)
            .primaryColor),
        const SizedBox(height: 8),
        Text(label, style: Theme
            .of(context)
            .textTheme
            .bodyMedium),
      ],
    );
  }
}