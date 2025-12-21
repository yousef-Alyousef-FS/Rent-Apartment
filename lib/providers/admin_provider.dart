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

  /// Loads mock data for UI testing.
  void loadMockData() {
    _status = AdminStatus.Loading;
    notifyListeners();
    // Simulate a small delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _pendingUsers = [
        User(id: 101, first_name: 'Ahmad', last_name: 'Nasser', phone: '555-0101'),
        User(id: 102, first_name: 'Fatima', last_name: 'Zahra', phone: '555-0102'),
        User(id: 103, first_name: 'Youssef', last_name: 'Khaled', phone: '555-0103'),
      ];
      _status = AdminStatus.Loaded;
      _errorMessage = null;
      notifyListeners();
    });
  }

  // --- Real API Methods ---

  Future<bool> login(String email, String password) async {
    // ... (real implementation)
    return false;
  }

  Future<void> fetchPendingUsers() async {
    // ... (real implementation)
  }

  Future<void> approveUser(int userId) async {
    // For mock purposes, just remove the user from the list
    _pendingUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
    print("Mock: Approved user $userId");
  }

  Future<void> deleteUser(int userId) async {
    // For mock purposes, just remove the user from the list
    _pendingUsers.removeWhere((user) => user.id == userId);
    notifyListeners();
    print("Mock: Deleted user $userId");
  }

  void logout() {
    _adminUser = null;
    _pendingUsers = [];
    _status = AdminStatus.Idle;
    notifyListeners();
  }
}
