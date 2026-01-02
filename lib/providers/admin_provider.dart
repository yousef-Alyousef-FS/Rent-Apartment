import 'package:flutter/material.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/services/APIs/admin_api_service.dart';

enum AdminStatus { Idle, Loading, Loaded, Error }

class AdminProvider with ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();
  User? _adminUser;
  
  AdminStatus _status = AdminStatus.Idle;
  String? _errorMessage;

  // --- UPDATED: Separated lists for clarity ---
  List<User> _pendingUsers = [];
  List<User> _allUsers = [];

  // Getters
  AdminStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAdminLoggedIn => _adminUser != null && _adminUser!.token != null;
  List<User> get pendingUsers => _pendingUsers;
  List<User> get allUsers => _allUsers;

  Future<bool> login(String phone, String password) async {
    _status = AdminStatus.Loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _adminUser = await _apiService.adminLogin(phone, password);
      if (isAdminLoggedIn) {
        // Fetch both lists on successful login
        await Future.wait([fetchPendingUsers(), fetchAllUsers()]);
      }
      return isAdminLoggedIn;
    } catch (e) {
      _status = AdminStatus.Error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchPendingUsers() async {
    if (!isAdminLoggedIn) return;
    _status = AdminStatus.Loading;
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

  // --- NEW: Function to fetch all users ---
  Future<void> fetchAllUsers() async {
    if (!isAdminLoggedIn) return;
    _status = AdminStatus.Loading;
    notifyListeners();
    try {
      _allUsers = await _apiService.getAllUsers(_adminUser!.token!);
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
      await _apiService.acceptUser(userId, _adminUser!.token!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      // Optionally, update the status of the user in the _allUsers list
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
      await _apiService.rejectUser(userId, _adminUser!.token!);
      _pendingUsers.removeWhere((user) => user.id == userId);
       final userIndex = _allUsers.indexWhere((u) => u.id == userId);
      if(userIndex != -1) _allUsers[userIndex] = _allUsers[userIndex].copyWith(status: 'rejected');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // --- UPDATED: Now removes user from both lists ---
  Future<void> deleteUser(int userId) async {
    if (!isAdminLoggedIn) return;
    try {
      await _apiService.deleteUser(userId, _adminUser!.token!);
      _pendingUsers.removeWhere((user) => user.id == userId);
      _allUsers.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void logout() {
    _adminUser = null;
    _pendingUsers = [];
    _allUsers = [];
    _status = AdminStatus.Idle;
    notifyListeners();
  }
}
