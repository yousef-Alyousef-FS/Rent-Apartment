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
  List<Apartment> _myApartments = [];
  String? _errorMessage;

  // Store the last used filters
  Map<String, String>? _lastFilters;

  ApartmentStatus get status => _status;
  List<Apartment> get apartments => _apartments;
  List<Apartment> get myApartments => _myApartments;
  String? get errorMessage => _errorMessage;

  void update(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  String? get _token => _userProvider?.token;

  // Modified to accept and store filters
  Future<void> fetchApartments({Map<String, String>? filters}) async {
    if (_token == null) return;
    _status = ApartmentStatus.Loading;
    _lastFilters = filters; // Save the filters for refresh
    notifyListeners();

    try {
      _apartments = await _apiService.getApartments(_token!, filters: _lastFilters);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> refreshApartments() async {
    // A new method to re-fetch with the last used filters
    await fetchApartments(filters: _lastFilters);
  }

  Future<void> fetchMyApartments() async {
    if (_token == null) return;
    _status = ApartmentStatus.Loading;
    notifyListeners();

    try {
      _myApartments = await _apiService.getMyApartments(_token!);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addApartment(Apartment apartment) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final newApartment = await _apiService.addApartment(apartment, _token!);
      _myApartments.add(newApartment);
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
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final updatedApartment = await _apiService.updateApartment(apartment, _token!);
      final index = _apartments.indexWhere((a) => a.id == updatedApartment.id);
      if (index != -1) {
        _apartments[index] = updatedApartment;
      }
      final myIndex = _myApartments.indexWhere((a) => a.id == updatedApartment.id);
      if (myIndex != -1) {
        _myApartments[myIndex] = updatedApartment;
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
