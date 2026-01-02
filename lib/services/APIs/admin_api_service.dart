import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/user.dart';
import '../../settings/connection.dart';

class AdminApiService
{
    static const String _baseUrl = Connection.emulator_baseUrl;

    Future<User> adminLogin(String phone, String password) async
    {
        final response = await http.post(
            Uri.parse('$_baseUrl/login_admin'),
            headers: {'Content-Type': 'application/json; charset=UTF-8', 'Accept': 'application/json'},
            body: jsonEncode({'phone': phone, 'password': password})
        );
        if (response.statusCode == 200)
        {
            return User.fromJson(jsonDecode(response.body));
        }
        else
        {
            throw Exception('Failed to login as admin. Status: ${response.statusCode}, Body: ${response.body}');
        }
    }

    // --- NEW: Function to get all users ---
    Future<List<User>> getAllUsers(String adminToken) async
    {
        final response = await http.get(
            Uri.parse('$_baseUrl/get_All_Users'),
            headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'}
        );
        if (response.statusCode == 200)
        {
            final List<dynamic> data = jsonDecode(response.body)['data'];
            return data.map((json) => User.fromJson(json)).toList();
        }
        else
        {
            throw Exception('Failed to fetch all users. Status: ${response.statusCode}');
        }
    }

    Future<List<User>> getPendingUsers(String adminToken) async
    {
        final response = await http.get(
            Uri.parse('$_baseUrl/pending_users'),
            headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'}
        );
        if (response.statusCode == 200)
        {
            final List<dynamic> data = jsonDecode(response.body)['data'];
            return data.map((json) => User.fromJson(json)).toList();
        }
        else
        {
            throw Exception('Failed to fetch pending users. Status: ${response.statusCode}');
        }
    }

    Future<void> acceptUser(int userId, String adminToken) async
    {
        final response = await http.patch(
            Uri.parse('$_baseUrl/accept_user/$userId'),
            headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'}
        );
        if (response.statusCode != 200)
        {
            throw Exception('Failed to accept user. Status: ${response.statusCode}');
        }
    }

    Future<void> rejectUser(int userId, String adminToken) async
    {
        final response = await http.patch(
            Uri.parse('$_baseUrl/reject_user/$userId'),
            headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'}
        );
        if (response.statusCode != 200)
        {
            throw Exception('Failed to reject user. Status: ${response.statusCode}');
        }
    }

    Future<void> deleteUser(int userId, String adminToken) async
    {
        final response = await http.delete(
            Uri.parse('$_baseUrl/delete_user/$userId'),
            headers: {'Authorization': 'Bearer $adminToken', 'Accept': 'application/json'}
        );
        if (response.statusCode != 200 && response.statusCode != 204)
        {
            throw Exception('Failed to delete user. Status: ${response.statusCode}');
        }
    }
}
