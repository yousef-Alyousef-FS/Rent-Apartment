import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/apartment.dart';
import 'package:plproject/settings/connection.dart';

class ApartmentApiService {
  get _baseUrl => Connection.emulator_baseUrl;

  // Modified to accept optional filter parameters
  Future<List<Apartment>> getApartments(String token, {Map<String, String>? filters}) async {
    // Dynamically build the URI with query parameters if filters are provided
    final uri = Uri.parse('$_baseUrl/apartments').replace(queryParameters: filters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load apartments. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<Apartment>> getMyApartments(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/my-apartments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my apartments. Status: ${response.statusCode}');
    }
  }

  Future<Apartment> addApartment(Apartment apartment, String token) async {
    final response = await http.post(Uri.parse('$_baseUrl/apartments'), headers: {'Content-Type':'application/json','Authorization':'Bearer $token','Accept':'application/json'}, body: jsonEncode(apartment.toJson()));
    if (response.statusCode==201) {return Apartment.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to add apartment. Status: ${response.statusCode}, Body: ${response.body}');}
  }

  Future<Apartment> updateApartment(Apartment apartment, String token) async {
    final response = await http.put(Uri.parse('$_baseUrl/apartments/${apartment.id}'), headers: {'Content-Type':'application/json','Authorization':'Bearer $token','Accept':'application/json'}, body: jsonEncode(apartment.toJson()));
    if (response.statusCode==200) {return Apartment.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to update apartment. Status: ${response.statusCode}, Body: ${response.body}');}
  }
}
