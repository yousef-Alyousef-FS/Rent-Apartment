import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sakani/models/user.dart';
import '../../settings/connection.dart';

class AdminApiService {
  static const String _baseUrl = Connection.emulator_baseUrl;

  Future<String> adminLogin(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login_admin'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'] as String;
      return token;
    } else {
      throw Exception('Failed to login as admin. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // --- REBUILT: To match the actual API response structure ---
  Future<List<User>> getAllUsers(String adminToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_All_Users'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // CORRECTED: The user list is directly in the 'data' field, not nested.
      if (responseBody['data'] is List) {
        final List<dynamic> data = responseBody['data'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch all users. Status: ${response.statusCode}');
    }
  }

  Future<List<User>> getPendingUsers(String adminToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pending_users'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['data'] is List) {
        final List<dynamic> data = responseBody['data'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } 
    else if (response.statusCode == 404) {
      return [];
    } 
    else {
      throw Exception('Failed to fetch pending users. Status: ${response.statusCode}');
    }
  }

  Future<void> acceptUser(int userId, String adminToken) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/accept_user/$userId'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept user. Status: ${response.statusCode}');
    }
  }

  Future<void> rejectUser(int userId, String adminToken) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/reject_user/$userId'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject user. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(int userId, String adminToken) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete_user/$userId'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user. Status: ${response.statusCode}');
    }
  }
}
