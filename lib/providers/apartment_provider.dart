import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/services/APIs/apartment_api_service.dart';

enum ApartmentStatus { Idle, Loading, Loaded, Error }

class ApartmentProvider with ChangeNotifier {
  final ApartmentApiService _apiService = ApartmentApiService();

  ApartmentStatus _status = ApartmentStatus.Idle;
  List<Apartment> _apartments = [];
  String? _errorMessage;

  // Getters
  ApartmentStatus get status => _status;
  List<Apartment> get apartments => _apartments;
  String? get errorMessage => _errorMessage;

  Future<void> fetchApartments(String token) async {
    _status = ApartmentStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _apartments = await _apiService.getApartments(token);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addApartment(Apartment apartment, String token) async {
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final newApartment = await _apiService.addApartment(apartment, token);
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

  Future<bool> updateApartment(Apartment apartment, String token) async {
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final updatedApartment = await _apiService.updateApartment(apartment, token);
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
