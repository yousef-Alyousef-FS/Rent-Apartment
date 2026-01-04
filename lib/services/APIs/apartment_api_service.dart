import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/settings/connection.dart';

class ApartmentApiService {
  get _baseUrl => Connection.emulator_baseUrl;

  Future<List<Apartment>> getAllApartments(String token) async {
    final uri = Uri.parse('$_baseUrl/apartments');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load apartments: ${response.body}');
    }
  }

  Future<List<Apartment>> searchApartments(String token, {Map<String, String>? filters}) async {
    final uri = Uri.parse('$_baseUrl/apartments/search').replace(queryParameters: filters);
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search apartments: ${response.body}');
    }
  }

  Future<List<Apartment>> getMyApartments(String token) async {
    final uri = Uri.parse('$_baseUrl/my_apartments');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['apartments'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my apartments: ${response.body}');
    }
  }

  Future<Apartment> createApartment(Map<String, String> apartmentData, List<XFile> images, String token) async {
    final uri = Uri.parse('$_baseUrl/apartment');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    request.fields.addAll(apartmentData);

    for (var imageFile in images) {
      request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return Apartment.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to add apartment: ${response.body}');
    }
  }

  // --- SIMPLIFIED: This function now ONLY updates textual data ---
  Future<Apartment> updateApartmentDetails(int apartmentId, String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/apartments/$apartmentId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return Apartment.fromJson(jsonDecode(response.body)['apartment']);
    } else {
      throw Exception('Failed to update apartment details: ${response.body}');
    }
  }

  // --- DELETED: addApartmentImages and deleteApartmentImages are removed as they are not required ---

  Future<void> deleteApartment(int apartmentId, String token) async {
     final uri = Uri.parse('$_baseUrl/apartment').replace(queryParameters: {'id': apartmentId.toString()});
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) { 
      throw Exception('Failed to delete apartment: ${response.body}');
    }
  }
}
