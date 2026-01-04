import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/screens/booking/booking_success_screen.dart';
import 'package:plproject/generated/app_localizations.dart';

class BookingScreen extends StatefulWidget {
  final Apartment apartment;

  const BookingScreen({super.key, required this.apartment});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 6));

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  // --- UPDATED: To handle the returned booking object ---
  Future<void> _confirmBooking() async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final loc = AppLocalizations.of(context)!;

    final newBooking = await bookingProvider.createBooking(
      apartmentId: widget.apartment.id,
      checkIn: _checkInDate,
      checkOut: _checkOutDate,
    );

    if (mounted) {
      if (newBooking != null) {
        Navigator.of(context).pushAndRemoveUntil(
          // Pass the new booking to the success screen
          MaterialPageRoute(builder: (context) => BookingSuccessScreen(booking: newBooking)),
          (route) => route.isFirst,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.errorMessage ?? loc.failedToCreateBooking),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final nights = _checkOutDate.difference(_checkInDate).inDays;
    final double totalCost = nights > 0 ? nights * widget.apartment.price : 0;

    return Scaffold(
      appBar: AppBar(title: Text(loc.confirmBooking)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildApartmentSummary(context, theme, widget.apartment),
          const Divider(height: 32),
          _buildDateSelector(context, theme, loc.checkIn, _checkInDate, () => _selectDate(context, true)),
          const SizedBox(height: 16),
          _buildDateSelector(context, theme, loc.checkOut, _checkOutDate, () => _selectDate(context, false)),
          const Divider(height: 32),
          _buildCostSummary(theme, loc, widget.apartment.price, nights, totalCost),
        ],
      ),
      bottomNavigationBar: _buildConfirmButton(context),
    );
  }

  Widget _buildApartmentSummary(BuildContext context, ThemeData theme,
      Apartment apartment) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            apartment.imageUrls.isNotEmpty ? apartment.imageUrls[0] : '',
            width: 100, height: 100, fit: BoxFit.cover,
            errorBuilder: (c, e, s) =>
                Container(width: 100, height: 100, color: Colors.grey[200]),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(apartment.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '${apartment.city ?? ''}, ${apartment.governorate ?? ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, ThemeData theme, String label,
      DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            Row(
              children: [
                Text(
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date
                      .day.toString().padLeft(2, '0')}",
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostSummary(ThemeData theme, AppLocalizations loc,
      double pricePerNight, int nights, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.costSummary, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(loc.pricePerNightLabel, style: theme.textTheme.bodyLarge),
            Text('\$${pricePerNight.toStringAsFixed(0)}',
                style: theme.textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(loc.numberOfNights, style: theme.textTheme.bodyLarge),
            Text(nights.toString(), style: theme.textTheme.bodyLarge),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(loc.totalCost, style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold)),
            Text('\$${total.toStringAsFixed(0)}',
                style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          return ElevatedButton(
            onPressed: provider.status == BookingStatusState.Loading
                ? null
                : _confirmBooking,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50)),
            child: provider.status == BookingStatusState.Loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Confirm and Pay'),
          );
        },
      ),
    );
  }}
