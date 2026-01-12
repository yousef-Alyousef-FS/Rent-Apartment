import 'package:flutter/material.dart';
import 'package:sakani/models/booking.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/services/APIs/booking_api_service.dart';

enum BookingStatusState { Idle, Loading, Loaded, Error }

class BookingProvider with ChangeNotifier {
  final BookingApiService _apiService = BookingApiService();
  UserProvider? _userProvider;

  BookingStatusState _status = BookingStatusState.Idle;
  String? _errorMessage;
  List<Booking> _myBookings = [];
  List<Booking> _ownerBookings = [];

  // Getters
  BookingStatusState get status => _status;
  String? get errorMessage => _errorMessage;
  List<Booking> get myBookings => _myBookings;
  List<Booking> get ownerBookings => _ownerBookings;

  void update(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  String? get _token => _userProvider?.token;

  Future<Booking?> createBooking({
    required int apartmentId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async
  {
    if (_token == null) {
      _errorMessage = "Authentication token not found.";
      return null;
    }
    _status = BookingStatusState.Loading;
    notifyListeners();

    try {
      final bookingData = {
        'apartment_id': apartmentId,
        'check_in_date': checkIn.toIso8601String().split('T')[0],
        'check_out_date': checkOut.toIso8601String().split('T')[0],
      };
      final newBooking = await _apiService.createBooking(bookingData, _token!);
      _myBookings.insert(0, newBooking);
      _status = BookingStatusState.Loaded;
      notifyListeners();
      return newBooking;
    } catch (e) {
      _errorMessage = e.toString();
      _status = BookingStatusState.Error;
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchMyBookings({bool forceRefresh = false}) async {
    if (_token == null) return;
    if (_status == BookingStatusState.Loading && !forceRefresh) return;
    if (_myBookings.isNotEmpty && !forceRefresh) return;

    _status = BookingStatusState.Loading;
    notifyListeners();
    try {
      _myBookings = await _apiService.getMyBookings(_token!);
      _status = BookingStatusState.Loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = BookingStatusState.Error;
    }
    notifyListeners();
  }

  Future<void> fetchOwnerBookings({bool forceRefresh = false}) async {
    if (_token == null) return;
    if (_status == BookingStatusState.Loading && !forceRefresh) return;
    if (_ownerBookings.isNotEmpty && !forceRefresh) return;

    _status = BookingStatusState.Loading;
    notifyListeners();
    try {
      _ownerBookings = await _apiService.getOwnerBookings(_token!);
      _status = BookingStatusState.Loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = BookingStatusState.Error;
    }
    notifyListeners();
  }

  Future<bool> cancelBooking(int bookingId) async {
    if (_token == null) return false;
    _status = BookingStatusState.Loading;
    notifyListeners();

    try {
      await _apiService.cancelBooking(bookingId, _token!);
      _myBookings.removeWhere((b) => b.id == bookingId);
      _ownerBookings.removeWhere((b) => b.id == bookingId);
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

  Future<bool> requestBookingUpdate({
    required int bookingId,
    required DateTime newCheckIn,
    required DateTime newCheckOut,
  }) async {
    if (_token == null) {
      _errorMessage = "Authentication token not found.";
      return false;
    }
    _status = BookingStatusState.Loading;
    notifyListeners();

    try {
      final updateData = {
        'check_in_date': newCheckIn.toIso8601String().split('T')[0],
        'check_out_date': newCheckOut.toIso8601String().split('T')[0],
      };
      final updatedBooking = await _apiService.updateBooking(bookingId, updateData, _token!);

      final myIndex = _myBookings.indexWhere((b) => b.id == bookingId);
      if (myIndex != -1) {
        _myBookings[myIndex] = updatedBooking;
      }
      final ownerIndex = _ownerBookings.indexWhere((b) => b.id == bookingId);
      if (ownerIndex != -1) {
        _ownerBookings[ownerIndex] = updatedBooking;
      }

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

  // --- UPDATED: Implemented the approve booking logic ---
  Future<bool> approveBooking(int bookingId) async {
    if (_token == null) return false;
    try {
      final updatedBooking = await _apiService.approveBooking(bookingId, _token!);
      final index = _ownerBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _ownerBookings[index] = updatedBooking;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners(); // Notify UI of the error
      return false;
    }
  }

  // --- UPDATED: Implemented the reject booking logic ---
  Future<bool> rejectBooking(int bookingId) async {
    if (_token == null) return false;
    try {
      final updatedBooking = await _apiService.rejectBooking(bookingId, _token!);
      final index = _ownerBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _ownerBookings[index] = updatedBooking;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners(); // Notify UI of the error
      return false;
    }
  }
}
