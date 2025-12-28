import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/services/APIs/user_api_service.dart';

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
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteApartmentIds = favoriteIdsAsString.map((id) => int.parse(id)).toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = _favoriteApartmentIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIdsAsString);
  }

  bool isFavorite(int apartmentId) {
    return _favoriteApartmentIds.contains(apartmentId);
  }

  void toggleFavorite(int apartmentId) {
    if (isFavorite(apartmentId)) {
      _favoriteApartmentIds.remove(apartmentId);
    } else {
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
    String? dateOfBirth,
    XFile? personalImage,
    XFile? idCardImage,
  }) async {
    _status = UserStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final registeredUser = await _apiService.register(
        phone: phone, password: password, firstName: firstName, lastName: lastName,
        dateOfBirth: dateOfBirth, personalImage: personalImage, idCardImage: idCardImage,
      );
      _user = registeredUser;
      _token = registeredUser.token;
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
    _favoriteApartmentIds = []; // Clear favorites on logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_favoritesKey);
    notifyListeners();
  }
}
