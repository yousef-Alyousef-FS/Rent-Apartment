import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakani/models/booking.dart';
import 'package:sakani/settings/connection.dart';

class BookingApiService {
  static const String _baseUrl = Connection.emulator_baseUrl;

  Future<Booking> createBooking(Map<String, dynamic> bookingData, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode({
        'apartment_id': bookingData['apartment_id'],
        'start_date': bookingData['check_in_date'],
        'end_date': bookingData['check_out_date'],
      }),
    );
    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body)['booking']);
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  Future<List<Booking>> getMyBookings(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bookings/user_bookings'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my bookings: ${response.body}');
    }
  }

  // --- CORRECTED ---
  Future<List<Booking>> getOwnerBookings(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/owner/bookings'), 
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data']['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load owner bookings: ${response.body}');
    }
  }

  Future<Booking> updateBooking(int bookingId, Map<String, dynamic> updateData, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/$bookingId/update'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode({
        'start_date': updateData['check_in_date'],
        'end_date': updateData['check_out_date'],
      }),
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body)['booking']);
    } else {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

  Future<void> cancelBooking(int bookingId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings/$bookingId/cancel'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking: ${response.body}');
    }
  }

  Future<Booking> approveBooking(int bookingId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings/$bookingId/approve'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body)['booking']);
    } else {
      throw Exception('Failed to approve booking: ${response.body}');
    }
  }

  Future<Booking> rejectBooking(int bookingId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings/$bookingId/reject'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body)['booking']);
    } else {
      throw Exception('Failed to reject booking: ${response.body}');
    }
  }
}
