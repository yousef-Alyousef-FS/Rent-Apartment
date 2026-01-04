import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/settings/connection.dart';

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
    final request = http.MultipartRequest('POST', uri)..headers['Accept'] = 'application/json';

    request.fields['phone'] = phone;
    request.fields['password'] = password;
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

  Future<User> updateUserProfile(String token, {
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    XFile? personalImage,
  }) async {
    final uri = Uri.parse('$_baseUrl/user/update');
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['available'] as bool;
    } else {
      throw Exception('Failed to check phone availability');
    }
  }

  // --- FAVORITES API METHODS ---

  Future<List<int>> getFavorites(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/favorites'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((id) => id as int).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> addFavorite(String token, int apartmentId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({'apartment_id': apartmentId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add favorite');
    }
  }

  Future<void> removeFavorite(String token, int apartmentId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/favorites/$apartmentId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to remove favorite');
    }
  }
}
