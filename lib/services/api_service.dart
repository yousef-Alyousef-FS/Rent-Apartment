import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/user.dart';

// TODO: Add the http package to your pubspec.yaml file:
// dependencies:
//   http: ^1.2.1

class ApiService {
  // TODO: Replace with your actual API base URL
  static const String _baseUrl = 'https://your-api-base-url.com/api';

  /// Sends a login request to the API.
  /// 
  /// Returns a [User] object if the login is successful.
  /// Throws an [Exception] if the login fails.
  Future<User> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // The API is expected to return the user and token directly.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // You can handle different error codes (e.g., 401, 404) here.
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  /// Sends a registration request to the API.
  /// 
  /// Returns a [User] object if the registration is successful.
  /// Throws an [Exception] if the registration fails.
  Future<User> register(User user, String password) async {
    final Map<String, dynamic> requestBody = user.toJson();
    requestBody['password'] = password; // Assuming the API needs the password here.

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) { // HTTP 201 Created
      // The API might return the new user object (and maybe a token).
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register. Status code: ${response.statusCode}');
    }
  }

  /// Fetches the user profile from the API using an authentication token.
  /// 
  /// Returns a [User] object.
  /// Throws an [Exception] if the request fails.
  Future<User> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile. Status code: ${response.statusCode}');
    }
  }

  /// Updates the user profile on the API.
  /// 
  /// Requires the full [User] object including the token.
  /// Returns the updated [User] object.
  /// Throws an [Exception] if the update fails.
  Future<User> updateUserProfile(User user) async {
    if (user.token == null) {
      throw Exception('Authentication token is required for this operation.');
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/user/profile'), // Assuming a PUT request to the same endpoint
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${user.token}',
      },
      body: jsonEncode(user.toJson()), // Sending the user data to update
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // The server might not return the full user object, or the token.
      // We create a new User object from the response and preserve the original token.
      final updatedUser = User.fromJson(responseData);
      // A better approach is to make the User class immutable and use a copyWith method.
      return user.copyWith(
        firstName: updatedUser.firstName,
        lastName: updatedUser.lastName,
        dateOfBirth: updatedUser.dateOfBirth,
        phone: updatedUser.phone,
        personalImagePath: updatedUser.personalImagePath,
        idCardImagePath: updatedUser.idCardImagePath,
      );
    } else {
      throw Exception('Failed to update profile. Status code: ${response.statusCode}');
    }
  }
}
