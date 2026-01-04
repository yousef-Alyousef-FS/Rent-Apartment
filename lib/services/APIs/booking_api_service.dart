import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/booking.dart';
import 'package:plproject/settings/connection.dart';

class BookingApiService {
  static const String _baseUrl = Connection.emulator_baseUrl;

  Future<Booking> createBooking(Map<String, dynamic> bookingData, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode(bookingData),
    );
    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  Future<List<Booking>> getMyBookings(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/my-bookings'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my bookings: ${response.body}');
    }
  }

  Future<List<Booking>> getOwnerBookings(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/owner/bookings'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load owner bookings: ${response.body}');
    }
  }

  Future<Booking> updateBooking(int bookingId, Map<String, dynamic> updateData, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/$bookingId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode(updateData),
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

  Future<void> cancelBooking(int bookingId, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/bookings/$bookingId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to cancel booking: ${response.body}');
    }
  }

  // --- NEW: Approve a booking request ---
  Future<Booking> approveBooking(int bookingId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/owner/bookings/$bookingId/approve'), // Assumed endpoint
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to approve booking: ${response.body}');
    }
  }

  // --- NEW: Reject a booking request ---
  Future<Booking> rejectBooking(int bookingId, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/owner/bookings/$bookingId/reject'), // Assumed endpoint
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reject booking: ${response.body}');
    }
  }
}
