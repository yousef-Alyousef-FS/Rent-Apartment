import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/booking.dart';
import 'package:plproject/settings/connection.dart';

class BookingApiService {
  get _baseUrl =>Connection.emulator_baseUrl;

  Future<List<Booking>> getUserBookings(String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/my-bookings'), headers: {'Authorization':'Bearer $token','Accept':'application/json'});
    if(response.statusCode==200){final List<dynamic> data=jsonDecode(response.body)['data'];return data.map((json)=>Booking.fromJson(json)).toList();}else{throw Exception('Failed to load user bookings. Status: ${response.statusCode}');}
  }

  Future<List<Booking>> getBookingRequests(String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/owner/booking-requests'), headers: {'Authorization': 'Bearer $token','Accept':'application/json'});
    if (response.statusCode == 200) {final List<dynamic> data = jsonDecode(response.body)['data']; return data.map((json) => Booking.fromJson(json)).toList();} else {throw Exception('Failed to load booking requests. Status: ${response.statusCode}');}
  }

  Future<Booking> createBooking(String token, {required int apartmentId, required DateTime checkIn, required DateTime checkOut}) async {
    final response = await http.post(Uri.parse('$_baseUrl/bookings'), headers: {'Content-Type':'application/json','Authorization':'Bearer $token','Accept':'application/json'}, body: jsonEncode({'apartment_id':apartmentId,'check_in_date':checkIn.toIso8601String(),'check_out_date':checkOut.toIso8601String(),}));
    if(response.statusCode==201){return Booking.fromJson(jsonDecode(response.body));}else{throw Exception('Failed to create booking. Status: ${response.statusCode}, Body: ${response.body}');}
  }

  // --- ADDED FOR UPDATE BOOKING FEATURE ---
  Future<Booking> requestBookingUpdate(String token, {required int bookingId, required DateTime newCheckIn, required DateTime newCheckOut}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/$bookingId'), 
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode({
        'check_in_date': newCheckIn.toIso8601String(),
        'check_out_date': newCheckOut.toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      return Booking.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to request booking update. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> cancelBooking(String token, int bookingId) async {
    final response = await http.post(Uri.parse('$_baseUrl/bookings/$bookingId/cancel'), headers: {'Authorization':'Bearer $token','Accept':'application/json'});
    if(response.statusCode!=200){throw Exception('Failed to cancel booking. Status: ${response.statusCode}');}
  }

  Future<Booking> approveBooking(String token, int bookingId) async {
    final response = await http.post(Uri.parse('$_baseUrl/owner/bookings/$bookingId/approve'), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {return Booking.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to approve booking. Status: ${response.statusCode}');}
  }

  Future<Booking> rejectBooking(String token, int bookingId) async {
    final response = await http.post(Uri.parse('$_baseUrl/owner/bookings/$bookingId/reject'), headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'});
    if (response.statusCode == 200) {return Booking.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to reject booking. Status: ${response.statusCode}');}
  }
}
