import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/services/APIs/user_api_service.dart';
import 'package:plproject/services/storage_service.dart';

enum UserStatus { Checking, Authenticated, Unauthenticated, Loading, Error }

class UserProvider with ChangeNotifier {
  final UserApiService _apiService = UserApiService();
  final StorageService _storageService = StorageService();
  static const String _tokenKey = 'auth_token';

  User? _user;
  String? _token;
  UserStatus _status = UserStatus.Checking;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  UserStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == UserStatus.Authenticated;

  UserProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    _status = UserStatus.Checking;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_tokenKey);

    if (storedToken == null) {
      _status = UserStatus.Unauthenticated;
      notifyListeners();
      return;
    }

    try {
      final userProfile = await _apiService.getUserProfile(storedToken);
      _user = userProfile;
      _token = storedToken;
      _status = UserStatus.Authenticated;
    } catch (e) {
      await prefs.remove(_tokenKey);
      _status = UserStatus.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final loggedInUser = await _apiService.login(phone, password);
      _user = loggedInUser;
      _token = loggedInUser.token;

      if (_token != null) {
        await _saveToken(_token!);
      }

      _status = UserStatus.Authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = UserStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    DateTime? dateOfBirth,
    XFile? personalImage,
    XFile? idCardImage,
  }) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      String? personalImageUrl;
      String? idCardImageUrl;
      if (personalImage != null) {
        personalImageUrl = await _storageService.uploadImage(personalImage.path);
      }
      if (idCardImage != null) {
        idCardImageUrl = await _storageService.uploadImage(idCardImage.path);
      }

      final userToRegister = User(
        first_name: firstName,
        last_name: lastName,
        dateOfBirth: dateOfBirth,
        phone: phone,
        password: password,
        profile_image: personalImageUrl,
        id_card_image: idCardImageUrl,
      );

      await _apiService.register(userToRegister);

      // On success, log the user in to get a token and complete the flow
      return await login(phone, password);

    } catch (e) {
      _status = UserStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkPhoneAndNavigate(String phone) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final isAvailable = await _apiService.checkPhoneAvailability(phone);
      if (isAvailable) {
        _status = UserStatus.Unauthenticated;
        notifyListeners();
        return true;
      } else {
        _status = UserStatus.Error;
        _errorMessage = "This phone number is already registered.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = UserStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  Future<void> logout() async {
    _user = null;
    _token = null;
    _status = UserStatus.Unauthenticated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }
}
