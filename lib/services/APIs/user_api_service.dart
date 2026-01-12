import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sakani/models/user.dart';
import 'package:sakani/settings/connection.dart';

class UserApiService {
  get _baseUrl => Connection.emulator_baseUrl;
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
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    if (dateOfBirth != null) request.fields['birth_date'] = dateOfBirth;

    if (personalImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', personalImage.path));
    }
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
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
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
  Future<User> updateUserProfile(String token, {
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    XFile? personalImage,
  }) async {
    final uri = Uri.parse('$_baseUrl/user/update'); // This endpoint does not exist yet
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';
    request.fields['_method'] = 'PUT';
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
  Future<void> changePassword(String token, {
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to change password: ${response.body}');
    }
  }
  Future<void> requestPasswordReset(String phone) async {
    await Future.delayed(const Duration(seconds: 1)); 
    throw Exception('This feature is not yet available on the server.');
  }
  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.body}');
    }
  }
  Future<bool> checkPhoneAvailability(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check_phone_availability'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return true; // Available
    } else if (response.statusCode == 409) {
      return false; // Already used
    } else {
      throw Exception('Failed to check phone availability: ${response.body}');
    }
  }
  Future<List<int>> getFavorites(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/favorites'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['favorites'] is List && body['favorites'].isEmpty) {
          return [];
      }
      if (body.containsKey('favorites') && body['favorites']['data'] is List) {
        final List<dynamic> data = body['favorites']['data'];
        return data.map((fav) => fav['apartment_id'] as int).toList();
      }
      return [];
    } else {
      throw Exception('Failed to load favorites: ${response.body}');
    }
  }
  Future<bool> toggleFavorite(String token, int apartmentId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/favorites/$apartmentId/toggle'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 201) {
      return true; // Added to favorites
    } else if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if(body['status'] == 'removed') {
        return false;
      }
    }
    throw Exception('Failed to toggle favorite: ${response.body}');
  }
}
