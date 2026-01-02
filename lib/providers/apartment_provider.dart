import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/services/APIs/apartment_api_service.dart';

enum ApartmentStatus { Idle, Loading, Loaded, Error }

class ApartmentProvider with ChangeNotifier {
  final ApartmentApiService _apiService = ApartmentApiService();
  UserProvider? _userProvider;

  ApartmentStatus _status = ApartmentStatus.Idle;
  String? _errorMessage;

  List<Apartment> _allApartments = [];
  List<Apartment> _featuredApartments = [];
  List<Apartment> _myApartments = [];

  ApartmentStatus get status => _status;
  List<Apartment> get allApartments => _allApartments;
  List<Apartment> get featuredApartments => _featuredApartments;
  List<Apartment> get myApartments => _myApartments;
  String? get errorMessage => _errorMessage;

  void update(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  String? get _token => _userProvider?.token;

  Future<void> fetchApartments() async {
    if (_token == null) return;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      _allApartments = await _apiService.getApartments(_token!);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> fetchFeaturedApartments() async {
    if (_token == null) return;
    try {
      final all = await _apiService.getApartments(_token!);
      _featuredApartments = all.take(5).toList();
    } catch (e) {
      print('Failed to fetch featured apartments: $e');
    }
    notifyListeners();
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

  // --- UPDATED: To handle images ---
  Future<bool> addApartment(Apartment apartment, List<XFile> images) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final newApartment = await _apiService.addApartment(apartment, images, _token!);
      _myApartments.insert(0, newApartment);
      _allApartments.insert(0, newApartment);
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

  // --- UPDATED: To handle image updates ---
  Future<bool> updateApartment(Apartment apartment, {List<XFile>? newImages, List<String>? deletedImageUrls}) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final updatedApartment = await _apiService.updateApartment(apartment, _token!, newImages: newImages, deletedImageUrls: deletedImageUrls);

      final allIndex = _allApartments.indexWhere((a) => a.id == updatedApartment.id);
      if (allIndex != -1) _allApartments[allIndex] = updatedApartment;

      final myIndex = _myApartments.indexWhere((a) => a.id == updatedApartment.id);
      if (myIndex != -1) _myApartments[myIndex] = updatedApartment;

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

  // --- NEW: Function to delete an apartment ---
  Future<bool> deleteApartment(int apartmentId) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      await _apiService.deleteApartment(apartmentId, _token!);
      _allApartments.removeWhere((a) => a.id == apartmentId);
      _myApartments.removeWhere((a) => a.id == apartmentId);
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