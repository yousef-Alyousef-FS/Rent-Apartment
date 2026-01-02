import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/settings/connection.dart';

class UserApiService {
  get _baseUrl => Connection.emulator_baseUrl;

  // --- UPDATED: To handle multipart request for image uploads ---
  Future<User> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    String? dateOfBirth,
    XFile? personalImage,
    XFile? idCardImage,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json';

    // Add text fields
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    if (dateOfBirth != null) request.fields['birth_date'] = dateOfBirth;

    // Add profile image if it exists
    if (personalImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', personalImage.path));
    }

    // Add ID card image if it exists
    if (idCardImage != null) {
      request.files.add(await http.MultipartFile.fromPath('id_card_image', idCardImage.path));
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<User> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/self'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user profile: ${response.statusCode}');
    }
  }

  // --- NEW: Function to update user profile ---
  Future<User> updateUserProfile(String token, {
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    XFile? personalImage,
  }) async {
    final uri = Uri.parse('$_baseUrl/user/update'); // This endpoint needs to be created in backend
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    request.fields['_method'] = 'PUT'; // Method spoofing for Laravel

    if (firstName != null) request.fields['first_name'] = firstName;
    if (lastName != null) request.fields['last_name'] = lastName;
    if (dateOfBirth != null) request.fields['birth_date'] = dateOfBirth;

    if (personalImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', personalImage.path));
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<void> logout(String token) async {
     await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }
  Future<bool> checkPhoneAvailability(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check_phone_availability'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['available'] as bool;
    } else {
      throw Exception('Failed to check phone availability');
    }
  }
}
