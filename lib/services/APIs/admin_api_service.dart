import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/user.dart';

import '../../settings/connection.dart';

class AdminApiService {

  static const String _baseUrl = Connection.chrome_baseUrl;

  Future<User> adminLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login as admin. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<User>> getPendingUsers(String adminToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/pending'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch pending users. Status: ${response.statusCode}');
    }
  }

  Future<void> approveUser(int userId, String adminToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/$userId/approve'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to approve user. Status: ${response.statusCode}');
    }
  }

  Future<void> deleteUser(int userId, String adminToken) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user. Status: ${response.statusCode}');
    }
  }

}
