import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/providers/booking_provider.dart';

class EditBookingScreen extends StatefulWidget {
  final Booking booking;
  const EditBookingScreen({super.key, required this.booking});

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  DateTime? _newCheckInDate;
  DateTime? _newCheckOutDate;

  @override
  void initState() {
    super.initState();
    _newCheckInDate = widget.booking.checkInDate;
    _newCheckOutDate = widget.booking.checkOutDate;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final initialDate = isCheckIn ? _newCheckInDate! : _newCheckOutDate!;
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate != null) {
      setState(() {
        if (isCheckIn) {
          _newCheckInDate = newDate;
          // Ensure check-out is after check-in
          if (_newCheckOutDate!.isBefore(_newCheckInDate!)) {
            _newCheckOutDate = _newCheckInDate!.add(const Duration(days: 1));
          }
        } else {
          _newCheckOutDate = newDate;
        }
      });
    }
  }

  void _submitUpdateRequest() {
    if (_newCheckInDate == null || _newCheckOutDate == null) return;

    Provider.of<BookingProvider>(context, listen: false).requestBookingUpdate(
      bookingId: widget.booking.id,
      newCheckIn: _newCheckInDate!,
      newCheckOut: _newCheckOutDate!,
    ).then((success) {
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Update request sent successfully!')));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send update request.'), backgroundColor: Colors.red));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apartment: ${widget.booking.apartment.title}', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            Text('Select new dates:', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateSelector(context, 'Check-in', _newCheckInDate!, () => _selectDate(context, true)),
                _buildDateSelector(context, 'Check-out', _newCheckOutDate!, () => _selectDate(context, false)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: provider.status == BookingStatusState.Loading ? null : _submitUpdateRequest,
          child: provider.status == BookingStatusState.Loading 
              ? const CircularProgressIndicator()
              : const Text('Request Update'),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, String label, DateTime date, VoidCallback onTap) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onTap,
          child: Text(date.toLocal().toString().split(' ')[0]),
        ),
      ],
    );
  }
}
