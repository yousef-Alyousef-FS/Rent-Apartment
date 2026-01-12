import 'package:flutter/material.dart';
import 'package:sakani/models/user.dart';
import 'package:sakani/services/APIs/admin_api_service.dart';

enum AdminStatus { Idle, Loading, Loaded, Error }

class AdminProvider with ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  
  // --- UPDATED: Store the token directly ---
  String? _adminToken;
  
  AdminStatus _status = AdminStatus.Idle;
  String? _errorMessage;

  List<User> _pendingUsers = [];
  List<User> _allUsers = [];

  // Getters
  AdminStatus get status => _status;
  String? get errorMessage => _errorMessage;
  // --- UPDATED: Logic now correctly checks for the token ---
  bool get isAdminLoggedIn => _adminToken != null;
  List<User> get pendingUsers => _pendingUsers;
  List<User> get allUsers => _allUsers;

  // --- UPDATED: Now handles a String token and fetches data on success ---
  Future<bool> login(String phone, String password) async {
    _status = AdminStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _adminToken = await _apiService.adminLogin(phone, password);
      if (isAdminLoggedIn) {
        // Fetch both lists on successful login
        await Future.wait([fetchPendingUsers(), fetchAllUsers()]);
        _status = AdminStatus.Loaded; // Set to Loaded after all data is fetched
      }
      notifyListeners();
      return isAdminLoggedIn;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // --- UPDATED: All subsequent calls use the stored _adminToken ---
  Future<void> fetchPendingUsers() async {
    if (!isAdminLoggedIn) return;
    _status = AdminStatus.Loading;
    notifyListeners();
    try {
      _pendingUsers = await _apiService.getPendingUsers(_adminToken!);
      _status = AdminStatus.Loaded;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchAllUsers() async {
    if (!isAdminLoggedIn) return;
    _status = AdminStatus.Loading;
    notifyListeners();
    try {
      _allUsers = await _apiService.getAllUsers(_adminToken!);
      _status = AdminStatus.Loaded;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> acceptUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.acceptUser(userId, _adminToken!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      final userIndex = _allUsers.indexWhere((u) => u.id == userId);
      if(userIndex != -1) _allUsers[userIndex] = _allUsers[userIndex].copyWith(status: 'approved');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> rejectUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.rejectUser(userId, _adminToken!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      final userIndex = _allUsers.indexWhere((u) => u.id == userId);
      if(userIndex != -1) _allUsers[userIndex] = _allUsers[userIndex].copyWith(status: 'rejected');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.deleteUser(userId, _adminToken!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      _allUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void logout() {
    _adminToken = null;
    _pendingUsers = [];
    _allUsers = [];
    _status = AdminStatus.Idle;
    notifyListeners();
  }
}
