import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/settings/connection.dart';

class ApartmentApiService {
  get _baseUrl => Connection.emulator_baseUrl;

  Future<List<Apartment>> getApartments(String token, {Map<String, String>? filters}) async {
    final uri = Uri.parse('$_baseUrl/apartments').replace(queryParameters: filters);
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

  Future<List<Apartment>> getMyApartments(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/my-apartments'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Apartment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my apartments: ${response.statusCode}');
    }
  }

  Future<Apartment> addApartment(Apartment apartment, List<XFile> images, String token) async {
    final uri = Uri.parse('$_baseUrl/apartments');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    final apartmentData = apartment.toJson();
    apartmentData.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    for (var imageFile in images) {
      request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 201) {
      return Apartment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add apartment: ${response.body}');
    }
  }

  // --- UPDATED: To handle multipart request for image updates and deletion ---
  Future<Apartment> updateApartment(Apartment apartment, String token, {List<XFile>? newImages, List<String>? deletedImageUrls}) async {
    final uri = Uri.parse('$_baseUrl/apartments/${apartment.id}');
    final request = http.MultipartRequest('POST', uri) // Using POST to spoof PUT
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    request.fields['_method'] = 'PUT';

    final apartmentData = apartment.toJson();
    apartmentData.forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    if (newImages != null) {
      for (var imageFile in newImages) {
        request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
      }
    }

    // --- NEW: Sending IDs of images to be deleted ---
    if (deletedImageUrls != null) {
      for (int i = 0; i < deletedImageUrls.length; i++) {
        // This key 'deleted_images' must be agreed upon with the backend team.
        request.fields['deleted_images[$i]'] = deletedImageUrls[i];
      }
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return Apartment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update apartment: ${response.body}');
    }
  }

  // --- NEW: Function to delete an apartment ---
  Future<void> deleteApartment(int apartmentId, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/apartments/$apartmentId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) { // 204 No Content is also a success
      throw Exception('Failed to delete apartment: ${response.body}');
    }
  }
}