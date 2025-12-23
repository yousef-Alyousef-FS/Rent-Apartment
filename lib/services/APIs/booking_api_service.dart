import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/booking.dart';
import 'package:plproject/settings/connection.dart';

class BookingApiService {
  final String _baseUrl = Connection.emulatorBaseUrl ;

  Future<List<Booking>> getUserBookings(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/my-bookings'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user bookings. Status: ${response.statusCode}');
    }
  }

  Future<Booking> createBooking(String token, {required int apartmentId, required DateTime checkIn, required DateTime checkOut}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'apartment_id': apartmentId,
        'check_in_date': checkIn.toIso8601String(),
        'check_out_date': checkOut.toIso8601String(),
      }),
    );
    if (response.statusCode == 201) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create booking. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> cancelBooking(String token, int bookingId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookings/$bookingId/cancel'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking. Status: ${response.statusCode}');
    }
  }
}
