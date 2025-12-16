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

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    tryAutoLogin();
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
      // Here, you could check if the user's profile is complete.
      // For now, we assume if they have a token, their profile is complete.
      _authStatus = AuthStatus.Authenticated;
    } catch (e) {
      await logout();
    }
    notifyListeners();
  }

  Future<void> login(String phone, String password) async {
    _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final loggedInUser = await _apiService.login(phone, password);
      _user = loggedInUser;
      _authStatus = AuthStatus.Authenticated;
      if (loggedInUser.token != null) {
        await _saveToken(loggedInUser.token!);
      }
    } catch (e) {
      _authStatus = AuthStatus.Unauthenticated;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<bool> register(String phone, String password) async {
    _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // The API is expected to create a user and return it with a token.
      final newUser = await _apiService.register(User(phone: phone), password);
      _user = newUser;
      _authStatus = AuthStatus.NeedsProfileCompletion; // Go to complete profile screen
      if (newUser.token != null) {
        await _saveToken(newUser.token!);
      }
      return true; // Indicate success
    } catch (e) {
      _authStatus = AuthStatus.Unauthenticated;
      _errorMessage = e.toString();
      return false; // Indicate failure
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateProfile(User userToUpdate) async {
     _authStatus = AuthStatus.Authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
       // Add the current token to the user object before sending
      userToUpdate.token = _user?.token;
      _user = await _apiService.updateUserProfile(userToUpdate);
      _authStatus = AuthStatus.Authenticated; // Profile is now complete!
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      // Stay on the profile page if it fails
      _authStatus = AuthStatus.NeedsProfileCompletion;
      return false;
    } finally {
      notifyListeners();
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
