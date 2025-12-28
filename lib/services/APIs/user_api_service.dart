import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/user.dart';
import 'package:plproject/settings/connection.dart';
import 'package:image_picker/image_picker.dart';

class UserApiService {
  get _baseUrl =>Connection.emulator_baseUrl;


  Future<User> login(String phone, String password) async {
    final response = await http.post(Uri.parse('$_baseUrl/login'), headers: {'Content-Type':'application/json; charset=UTF-8','Accept':'application/json'}, body: jsonEncode({'phone': phone, 'password': password}));
    if (response.statusCode == 200) {return User.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to login. Status: ${response.statusCode}, Body: ${response.body}');}
  }

  Future<bool> checkPhoneAvailability(String phone) async {
    final response = await http.post(Uri.parse('$_baseUrl/check_phone_availability'), headers: {'Content-Type':'application/json; charset=UTF-8','Accept':'application/json'}, body: jsonEncode({'phone': phone}));
    if (response.statusCode == 200)
    {return true;}
    // Reverting to 422 as it seems the provider logic expects it
    else if (response.statusCode == 409)
    {return false;}
    else {throw Exception('Error checking phone availability. Status: ${response.statusCode}, Body: ${response.body}');}
  }

  // --- REWRITTEN FOR MULTIPART REQUEST ---
  Future<User> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    String? dateOfBirth,
    XFile? personalImage,
    XFile? idCardImage,
  }) async
  {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/register'));

    // Add text fields
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    if (dateOfBirth != null) {
      request.fields['birth_date'] = dateOfBirth;
    }

    // Add profile image file
    if (personalImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        personalImage.path,
      ));
    }

    // Add ID card image file
    if (idCardImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'id_card_image',
        idCardImage.path,
      ));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      // The backend now returns the user and token directly
      final responseData = jsonDecode(response.body);
      // Manually add the token to the user object before creating it
      final userJson = responseData['user'];
      userJson['token'] = responseData['access_token'];
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to register. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<User> getUserProfile(String token) async {
    final response = await http.get(Uri.parse('$_baseUrl/user/profile'), headers: {'Content-Type':'application/json','Authorization':'Bearer $token','Accept':'application/json'});
    if (response.statusCode == 200) {return User.fromJson(jsonDecode(response.body));} else {throw Exception('Failed to load user profile. Status: ${response.statusCode}');}
  }
 
  Future<User> updateUserProfile(User user, String token) async {
    // This might also need to be a multipart request if the user can update their profile image
    final response = await http.put(Uri.parse('$_baseUrl/user/profile'), headers: {'Content-Type':'application/json; charset=UTF-8','Authorization':'Bearer $token','Accept':'application/json'}, body: jsonEncode(user.toJson()));
    if (response.statusCode == 200) {final updatedUser = User.fromJson(jsonDecode(response.body)); return user.copyWith(first_name: updatedUser.first_name, last_name: updatedUser.last_name);} else {throw Exception('Failed to update profile. Status: ${response.statusCode}, Body: ${response.body}');}
  }
}
