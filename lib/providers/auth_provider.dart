import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/APIs/user_api_service.dart';
import '../services/storage_service.dart';

enum AuthStatus {
  Unauthenticated,
  Authenticating,
  Authenticated,
  CheckingAuth,
  NeedsProfileCompletion,
  PendingApproval
}

class AuthProvider with ChangeNotifier {
  final UserApiService _apiService = UserApiService();
  final StorageService _storageService = StorageService();
  static const String _tokenKey = 'auth_token';

  AuthStatus _authStatus = AuthStatus.CheckingAuth;
  User? _user;
  String? _errorMessage;

  String? _tempPhone;
  String? _tempPassword;

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    tryAutoLogin();
  }

  void setAuthenticating() {
    _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    if (_authStatus != AuthStatus.NeedsProfileCompletion) {
      _authStatus = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_tokenKey)) {
      _authStatus = AuthStatus.Unauthenticated;
      notifyListeners();
      return;
    }
    final token = prefs.getString(_tokenKey)!;
    try {
      _user = await _apiService.getUserProfile(token);
      _authStatus = AuthStatus.Authenticated;
    } catch (e) {
      await logout();
    } finally {
      notifyListeners();
    }
  }

  Future<void> login(String phone, String password) async {
    setAuthenticating();
    try {
      final loggedInUser = await _apiService.login(phone, password);
      _user = loggedInUser;
      _authStatus = AuthStatus.Authenticated;
      if (loggedInUser.token != null) {
        await _saveToken(loggedInUser.token!);
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<bool> checkPhoneAndProceed(String phone, String password) async {
    setAuthenticating();
    try {
      final isAvailable = await _apiService.checkPhoneAvailability(phone);
      if (isAvailable) {
        _tempPhone = phone;
        _tempPassword = password;
        _authStatus = AuthStatus.NeedsProfileCompletion;
        notifyListeners();
        return true;
      } else {
        setError("This phone number is already registered.");
        return false;
      }
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<bool> register(User profileData, XFile? personalImage, XFile? idCardImage) async {
    if (_tempPhone == null || _tempPassword == null) {
      setError("Registration session expired. Please start over.");
      return false;
    }
    setAuthenticating();

    try {
      // 1. Upload images and get URLs
      String? personalImageUrl;
      String? idCardImageUrl;

      if (personalImage != null) {
        personalImageUrl = await _storageService.uploadImage(personalImage.path);
      }
      if (idCardImage != null) {
        idCardImageUrl = await _storageService.uploadImage(idCardImage.path);
      }

      // 2. Assemble the final User object
      profileData.phone = _tempPhone;
      profileData.password = _tempPassword;
      profileData.profile_image = personalImageUrl;
      profileData.id_card_image = idCardImageUrl;

      // 3. Create the user in the backend
      await _apiService.register(profileData);

      // 4. Immediately log in to get a token and user status
      await login(_tempPhone!, _tempPassword!); 

      _tempPhone = null;
      _tempPassword = null;
      return true;

    } catch (e) {
      _errorMessage = e.toString();
      _authStatus = AuthStatus.NeedsProfileCompletion;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _authStatus = AuthStatus.Unauthenticated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}
