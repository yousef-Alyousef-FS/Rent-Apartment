import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakani/services/APIs/user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakani/models/user.dart';

enum UserStatus {
  Checking, Authenticated, Unauthenticated, Loading, Error
}

class UserProvider with ChangeNotifier {
  final UserApiService _apiService = UserApiService();
  static const String _tokenKey = 'auth_token';

  User? _user;
  String? _token;
  UserStatus _status = UserStatus.Checking;
  String? _errorMessage;

  List<int> _favoriteApartmentIds = [];
  List<int> get favoriteApartmentIds => _favoriteApartmentIds;

  User? get user => _user;
  String? get token => _token;
  UserStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == UserStatus.Authenticated;

  UserProvider() {
    tryAutoLogin();
  }

  Future<void> _fetchFavorites() async {
    if (_token == null) return;
    try {
      _favoriteApartmentIds = await _apiService.getFavorites(_token!);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch favorites: $e');
    }
  }

  bool isFavorite(int apartmentId) {
    return _favoriteApartmentIds.contains(apartmentId);
  }

  // ---MODIFIED---
  Future<void> toggleFavorite(int apartmentId) async {
    if (_token == null) return;

    final isCurrentlyFavorite = isFavorite(apartmentId);
    // Optimistic UI update
    if (isCurrentlyFavorite) {
      _favoriteApartmentIds.remove(apartmentId);
    } else {
      _favoriteApartmentIds.add(apartmentId);
    }
    notifyListeners();

    try {
      await _apiService.toggleFavorite(_token!, apartmentId);
    } catch (e) {
      // Revert on error
      if (isCurrentlyFavorite) {
        _favoriteApartmentIds.add(apartmentId);
      } else {
        _favoriteApartmentIds.remove(apartmentId);
      }
      notifyListeners();
      // Optionally re-throw or handle the error message to show in the UI
    }
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
      if (userProfile.status == 'pending' || userProfile.status == 'rejected') {
        await logout();
        return;
      }
      _user = userProfile;
      _token = storedToken;
      _status = UserStatus.Authenticated;
      await _fetchFavorites();
    } catch (e) {
      await logout();
    }
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final loggedInUser = await _apiService.login(phone, password);
      if (loggedInUser.status == 'pending') {
        throw Exception('Your account is pending admin approval.');
      } else if (loggedInUser.status == 'rejected') {
        throw Exception('Your account has been rejected. Please contact support.');
      }
      _user = loggedInUser;
      _token = loggedInUser.token;
      if (_token != null) {
        await _saveToken(_token!);
      }
      _status = UserStatus.Authenticated;
      await _fetchFavorites();
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
    String? dateOfBirth,
    XFile? personalImage,
    XFile? idCardImage,
  }) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.register(
          phone: phone,
          password: password,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          personalImage: personalImage,
          idCardImage: idCardImage);
      _status = UserStatus.Unauthenticated;
      notifyListeners();
      return true;
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

  Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    XFile? personalImage,
  }) async {
    if (_token == null) return false;
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final updatedUser = await _apiService.updateUserProfile(_token!, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, personalImage: personalImage);
      _user = updatedUser.copyWith(token: _token);
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

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (_token == null) return false;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.changePassword(_token!, currentPassword: currentPassword, newPassword: newPassword, newPasswordConfirmation: newPasswordConfirmation);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestPasswordReset(String phone) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.requestPasswordReset(phone);
      _status = UserStatus.Unauthenticated;
      notifyListeners();
      return true;
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
    try {
      if (_token != null) await _apiService.logout(_token!);
    } catch (_) {}
    _user = null;
    _token = null;
    _status = UserStatus.Unauthenticated;
    _favoriteApartmentIds = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }
}
