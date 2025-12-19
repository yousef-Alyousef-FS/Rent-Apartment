import 'package:flutter/material.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/services/admin_api_service.dart';

enum AdminStatus { Idle, Loading, Loaded, Error }

class AdminProvider with ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  User? _adminUser;
  
  AdminStatus _status = AdminStatus.Idle;
  List<User> _pendingUsers = [];
  String? _errorMessage;

  // Getters
  AdminStatus get status => _status;
  List<User> get pendingUsers => _pendingUsers;
  String? get errorMessage => _errorMessage;
  bool get isAdminLoggedIn => _adminUser != null && _adminUser!.token != null;

  Future<bool> login(String email, String password) async {
    _status = AdminStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _adminUser = await _apiService.adminLogin(email, password);
      await fetchPendingUsers();
      return true;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchPendingUsers() async {
    if (!isAdminLoggedIn) return;
    _status = AdminStatus.Loading; // Corrected the typo
    notifyListeners();
    try {
      _pendingUsers = await _apiService.getPendingUsers(_adminUser!.token!);
      _status = AdminStatus.Loaded;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> approveUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.approveUser(userId, _adminUser!.token!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.deleteUser(userId, _adminUser!.token!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void logout() {
    _adminUser = null;
    _pendingUsers = [];
    _status = AdminStatus.Idle;
    notifyListeners();
  }
}
