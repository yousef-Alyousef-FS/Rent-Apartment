import 'package:flutter/material.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/services/APIs/booking_api_service.dart';

enum BookingStatusState { Idle, Loading, Loaded, Error }

class BookingProvider with ChangeNotifier {
  final BookingApiService _apiService = BookingApiService();

  BookingStatusState _status = BookingStatusState.Idle;
  List<Booking> _bookings = [];
  String? _errorMessage;

  // Getters
  BookingStatusState get status => _status;
  List<Booking> get bookings => _bookings;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserBookings(String token) async {
    _status = BookingStatusState.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await _apiService.getUserBookings(token);
      _status = BookingStatusState.Loaded;
    } catch (e) {
      _status = BookingStatusState.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> createBooking(String token, {required int apartmentId, required DateTime checkIn, required DateTime checkOut}) async {
    _status = BookingStatusState.Loading;
    notifyListeners();
    try {
      final newBooking = await _apiService.createBooking(token, apartmentId: apartmentId, checkIn: checkIn, checkOut: checkOut);
      _bookings.add(newBooking);
      _status = BookingStatusState.Loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = BookingStatusState.Error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelBooking(String token, int bookingId) async {
    final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex == -1) return false; 

    final originalBooking = _bookings[bookingIndex];
    _bookings[bookingIndex] = originalBooking.copyWith(status: 'cancelled');
    notifyListeners();

    try {
      await _apiService.cancelBooking(token, bookingId);
      return true;
    } catch (e) {
      _bookings[bookingIndex] = originalBooking;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
