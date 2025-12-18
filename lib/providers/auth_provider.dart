import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

enum AuthStatus { Unauthenticated, Authenticating, Authenticated, CheckingAuth, NeedsProfileCompletion }

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  static const String _tokenKey = 'auth_token';

  AuthStatus _authStatus = AuthStatus.CheckingAuth;
  User? _user;
  String? _errorMessage;

  // Temporary storage for the registration flow
  String? _tempPhone;
  String? _tempPassword;

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    tryAutoLogin();
  }

  Future<void> tryAutoLogin() async {
    // ... (existing implementation)
  }

  Future<void> login(String phone, String password) async {
    // ... (existing implementation)
  }

  /// Step 1 of Registration: Check phone and proceed to complete profile
  Future<bool> checkPhoneAndProceed(String phone, String password) async {
    _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final isAvailable = await _apiService.checkPhoneAvailability(phone);
      if (isAvailable) {
        _tempPhone = phone;
        _tempPassword = password;
        _authStatus = AuthStatus.NeedsProfileCompletion;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "This phone number is already registered.";
        _authStatus = AuthStatus.Unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _authStatus = AuthStatus.Unauthenticated;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Step 2 of Registration: Submit the complete profile
  Future<bool> register(User profileData) async {
    if (_tempPhone == null || _tempPassword == null) {
      _errorMessage = "Registration session expired. Please start over.";
      _authStatus = AuthStatus.Unauthenticated;
      notifyListeners();
      return false;
    }

    _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    // Combine temporary data with profile data
    profileData.phone = _tempPhone;
    profileData.password = _tempPassword;

    try {
      final newUser = await _apiService.register(profileData);
      _user = newUser;
      _authStatus = AuthStatus.Authenticated; // Registration complete!
      if (newUser.token != null) {
        await _saveToken(newUser.token!);
      }
      // Clear temporary data
      _tempPhone = null;
      _tempPassword = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      // Stay on the profile page if registration fails
      _authStatus = AuthStatus.NeedsProfileCompletion;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(User userToUpdate, String token) async {
     // ... (existing implementation)
     return false;
  }

  Future<void> logout() async {
    // ... (existing implementation)
  }

  Future<void> _saveToken(String token) async {
    // ... (existing implementation)
  }
}
