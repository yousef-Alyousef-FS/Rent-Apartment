import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plproject/services/APIs/user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plproject/models/user.dart';

enum UserStatus { Checking, Authenticated, Unauthenticated, Loading, Error }

class UserProvider with ChangeNotifier {
  final UserApiService _apiService = UserApiService();
  static const String _tokenKey = 'auth_token';
  static const String _favoritesKey = 'favorite_ids';

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

  Future<void> _loadFavorites() async
  {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteApartmentIds = favoriteIdsAsString.map((id) => int.parse(id)).toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async
  {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = _favoriteApartmentIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIdsAsString);
  }

  bool isFavorite(int apartmentId)
  {
    return _favoriteApartmentIds.contains(apartmentId);
  }

  void toggleFavorite(int apartmentId)
  {
    if (isFavorite(apartmentId))
    {
      _favoriteApartmentIds.remove(apartmentId);
    }
    else
    {
      _favoriteApartmentIds.add(apartmentId);
    }
    _saveFavorites();
    notifyListeners();
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
      await _loadFavorites();
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
      await _loadFavorites();
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
      // The apiService now handles the multipart request
      await _apiService.register(
        phone: phone,
        password: password,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        personalImage: personalImage,
        idCardImage: idCardImage,
      );
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

  Future<bool> checkPhoneAndNavigate(String phone) async
  {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try
    {
      final isAvailable = await _apiService.checkPhoneAvailability(phone);
      if (isAvailable)
      {
        _status = UserStatus.Unauthenticated;
        notifyListeners();
        return true;
      }
      else
      {
        _status = UserStatus.Error;
        _errorMessage = "This phone number is already registered.";
        notifyListeners();
        return false;
      }
    }
    catch (e)
    {
      _status = UserStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }


  // --- NEW: Function to update user profile ---
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
      final updatedUser = await _apiService.updateUserProfile(
        _token!,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        personalImage: personalImage,
      );
      // Update the local user object with the new data from the server
      _user = updatedUser.copyWith(token: _token); // Keep the existing token
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

  Future<void> _saveToken(String token) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> logout() async
  {
    _user = null;
    _token = null;
    _status = UserStatus.Unauthenticated;
    _favoriteApartmentIds = [];
    final prefs = await SharedPreferences.getInstance();
    // Try to inform the server about the logout, but don't block the user if it fails.
    try
    {
      if (_token != null) await _apiService.logout(_token!);
    }
    catch (_)
    {
      // Ignore errors on logout, the user should be logged out locally regardless.
    }
    await prefs.remove(_tokenKey);
    await prefs.remove(_favoritesKey);
    notifyListeners();
  }
}
