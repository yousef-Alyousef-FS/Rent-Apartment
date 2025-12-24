import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/services/APIs/apartment_api_service.dart';

enum ApartmentStatus { Idle, Loading, Loaded, Error }

class ApartmentProvider with ChangeNotifier {
  final ApartmentApiService _apiService = ApartmentApiService();
  UserProvider? _userProvider;

  ApartmentStatus _status = ApartmentStatus.Idle;
  List<Apartment> _apartments = [];
  String? _errorMessage;

  ApartmentStatus get status => _status;
  List<Apartment> get apartments => _apartments;
  String? get errorMessage => _errorMessage;

  // Method to update the internal UserProvider instance
  void update(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  // Updated to use the internal user provider for the token
  Future<void> fetchApartments() async {
    if (_userProvider == null || _userProvider!.token == null) {
      _status = ApartmentStatus.Error;
      _errorMessage = "User is not authenticated.";
      notifyListeners();
      return;
    }

    _status = ApartmentStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _apartments = await _apiService.getApartments(_userProvider!.token!);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addApartment(Apartment apartment) async {
     if (_userProvider == null || _userProvider!.token == null) return false;

    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final newApartment = await _apiService.addApartment(apartment, _userProvider!.token!);
      _apartments.add(newApartment);
      _status = ApartmentStatus.Loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ApartmentStatus.Error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateApartment(Apartment apartment) async {
    if (_userProvider == null || _userProvider!.token == null) return false;

    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final updatedApartment = await _apiService.updateApartment(apartment, _userProvider!.token!);
      final index = _apartments.indexWhere((a) => a.id == updatedApartment.id);
      if (index != -1) {
        _apartments[index] = updatedApartment;
      }
      _status = ApartmentStatus.Loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ApartmentStatus.Error;
      notifyListeners();
      return false;
    }
  }
}
