import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/user.dart';
import 'package:plproject/settings/connection.dart';

class UserApiService {
  final String _baseUrl = Connection.emulatorBaseUrl ;

  Future<User> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<bool> checkPhoneAvailability(String phone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/check_phone_availability'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 422) {
      return false;
    } else {
      throw Exception('Error checking phone availability. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<User> register(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<User> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/profile'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile. Status: ${response.statusCode}');
    }
  }

  Future<User> updateUserProfile(User user, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/user/profile'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      final updatedUser = User.fromJson(jsonDecode(response.body));
      return user.copyWith(first_name: updatedUser.first_name, last_name: updatedUser.last_name);
    } else {
      throw Exception('Failed to update profile. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
