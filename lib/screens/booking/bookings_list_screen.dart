import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/booking.dart';
import 'package:sakani/providers/booking_provider.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/booking/edit_booking_screen.dart';
import 'package:sakani/screens/booking/review_screen.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  int? _cancellingBookingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBookings(forceRefresh: true);
    });
  }

  Future<void> _fetchBookings({bool forceRefresh = false}) {
    return Provider.of<BookingProvider>(context, listen: false).fetchMyBookings(forceRefresh: forceRefresh);
  }

  void _showCancelDialog(BuildContext context, Booking booking, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.confirmCancellation),
        content: Text(loc.areYouSureCancelBooking),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(loc.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() => _cancellingBookingId = booking.id);

              final success = await Provider.of<BookingProvider>(context, listen: false).cancelBooking(booking.id);

              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.cancellationSuccess), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.cancellationError), backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }
                setState(() => _cancellingBookingId = null);
              }
            },
            child: Text(loc.yesCancel, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.myBookings),
          bottom: TabBar(tabs: [Tab(text: loc.pending), Tab(text: loc.completed), Tab(text: loc.cancelled)]),
        ),
        body: RefreshIndicator(
          onRefresh: () => _fetchBookings(forceRefresh: true),
          child: Consumer<BookingProvider>(
            builder: (context, provider, child) {
              if (provider.status == BookingStatusState.Loading && provider.myBookings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.status == BookingStatusState.Error && provider.myBookings.isEmpty) {
                return Center(child: Text(loc.errorOccurred(provider.errorMessage ?? '...')));
              }

              final pending = provider.myBookings.where((b) => b.status == 'pending_approval').toList();
              final completed = provider.myBookings.where((b) => b.status == 'completed' || b.status == 'confirmed').toList();
              final cancelled = provider.myBookings.where((b) => b.status == 'cancelled' || b.status == 'rejected').toList();

              return TabBarView(
                children: [
                  _buildBookingsList(pending, loc.noNewRequests, 'pending'),
                  _buildBookingsList(completed, loc.noCompletedBookings, 'completed'),
                  _buildBookingsList(cancelled, loc.noCancelledBookings, null),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String emptyMessage, String? actionsType) {
    if (bookings.isEmpty) {
      return Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.titleMedium));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index], actionsType);
      },
    );
  }

  Widget _buildBookingCard(Booking booking, String? actionsType) {
    final loc = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yMd', Localizations.localeOf(context).toLanguageTag());

    if (booking.apartment == null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.red.withOpacity(0.05),
        child: ListTile(
          leading: const Icon(Icons.error_outline, color: Colors.red),
          title: Text(loc.bookingDetailsUnavailable, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          subtitle: Text(loc.bookingId(booking.id.toString())),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    booking.apartment!.images.isNotEmpty ? booking.apartment!.images[0].imageUrl : '',
                    width: 80, height: 80, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80, height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.apartment, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.apartment!.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${loc.dates}: ${dateFormat.format(booking.checkInDate)} - ${dateFormat.format(booking.checkOutDate)}', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text('${loc.total}: \$${booking.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            if (actionsType != null)
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: _buildActionButtons(context, booking, actionsType, loc),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, Booking booking, String actionsType, AppLocalizations loc) {
    if (actionsType == 'pending') {
      return [
        TextButton(
          onPressed: booking.apartment != null ? () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => EditBookingScreen(booking: booking)));
          } : null,
          child: Text(loc.editBooking),
        ),
        _cancellingBookingId == booking.id
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : TextButton(
                onPressed: () => _showCancelDialog(context, booking, loc),
                child: Text(loc.cancel, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
      ];
    } else if (actionsType == 'completed') {
      return [
        TextButton(
          onPressed: booking.apartment != null ? () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ReviewScreen(apartmentId: booking.apartment!.id)));
          } : null,
          child: Text(loc.addReview),
        ),
      ];
    }
    return [];
  }
}
