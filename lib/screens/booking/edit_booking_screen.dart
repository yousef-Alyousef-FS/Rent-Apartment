import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/booking.dart';
import 'package:sakani/providers/booking_provider.dart';
import 'package:sakani/generated/app_localizations.dart';

class EditBookingScreen extends StatefulWidget
{
    final Booking booking;

    const EditBookingScreen({super.key, required this.booking});

    @override
    State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen>
{
    late DateTime _newCheckInDate;
    late DateTime _newCheckOutDate;
    bool _isLoading = false;

    @override
    void initState()
    {
        super.initState();
        _newCheckInDate = widget.booking.checkInDate;
        _newCheckOutDate = widget.booking.checkOutDate;
    }

    Future<void> _selectDate(BuildContext context, bool isCheckIn) async
    {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: isCheckIn ? _newCheckInDate : _newCheckOutDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101)
        );
        if (picked != null)
        {
            setState(()
                {
                    if (isCheckIn)
                    {
                        _newCheckInDate = picked;
                        if (_newCheckOutDate.isBefore(_newCheckInDate.add(const Duration(days: 1))))
                        {
                            _newCheckOutDate = _newCheckInDate.add(const Duration(days: 1));
                        }
                    }
                    else
                    {
                        _newCheckOutDate = picked;
                    }
                }
            );
        }
    }

    Future<void> _updateBooking() async
    {
        final provider = Provider.of<BookingProvider>(context, listen: false);
        final loc = AppLocalizations.of(context)!;

        setState(() => _isLoading = true);

        final success = await provider.requestBookingUpdate(
            bookingId: widget.booking.id,
            newCheckIn: _newCheckInDate,
            newCheckOut: _newCheckOutDate
        );

        if (mounted)
        {
            if (success)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.bookingUpdatedSuccess), backgroundColor: Colors.green)
                );
                Navigator.of(context).pop();
            }
            else
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(provider.errorMessage ?? loc.failedToUpdateBooking), backgroundColor: Theme.of(context).colorScheme.error)
                );
            }
            setState(() => _isLoading = false);
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final theme = Theme.of(context);
        final loc = AppLocalizations.of(context)!;

        return Scaffold(
            appBar: AppBar(
                title: Text(loc.editBooking)
            ),
            body: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                    Text(loc.selectNewDates, style: theme.textTheme.titleMedium),
                    // --- CORRECTED: Safely access the apartment title ---
                    Text(widget.booking.apartment?.title ?? '...', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const Divider(height: 32),
                    _buildDateSelector(context, theme, loc.checkIn, _newCheckInDate, () => _selectDate(context, true)),
                    const SizedBox(height: 16),
                    _buildDateSelector(context, theme, loc.checkOut, _newCheckOutDate, () => _selectDate(context, false))
                ]
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateBooking,
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                        : Text(loc.updateBooking)
                )
            )
        );
    }

    Widget _buildDateSelector(BuildContext context, ThemeData theme, String label, DateTime date, VoidCallback onTap)
    {
        final dateFormat = DateFormat('yMd', Localizations.localeOf(context).toLanguageTag());
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
                                    dateFormat.format(date),
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.calendar_month_outlined)
                            ]
                        )
                    ]
                )
            )
        );
    }
}
