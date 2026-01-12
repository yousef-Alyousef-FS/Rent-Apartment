import 'package:flutter/material.dart';
import 'package:sakani/models/booking.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/booking/bookings_list_screen.dart';

// RENAMED and REBUILT: To reflect that a request was sent, not that the booking is confirmed.
class BookingRequestSentScreen extends StatelessWidget {
  final Booking booking;

  const BookingRequestSentScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                // Use a more appropriate icon for a pending request
                child: Icon(Icons.outbox_rounded, color: theme.colorScheme.primary, size: 100),
              ),
              const SizedBox(height: 32),
              Text(
                loc.bookingRequestSent,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Text(
                loc.bookingRequestSentMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the bookings list so the user can see the pending request
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const BookingsListScreen(),
                    ),
                     (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text(loc.viewMyBookings),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(loc.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
