import 'package:flutter/material.dart';
import '../models/apartment.dart';
import '../services/api_service.dart';

enum ApartmentStatus { Idle, Loading, Loaded, Error }

class ApartmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

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
    } finally {
      notifyListeners();
    }
  }
}
