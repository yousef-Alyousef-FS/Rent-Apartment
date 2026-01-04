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
    if (_userProvider?.isLoggedIn == true) {
      fetchApartments();
      fetchFeaturedApartments();
    }
  }

  String? get _token => _userProvider?.token;

  Future<void> fetchApartments({Map<String, String>? filters}) async {
    if (_token == null) return;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      if (filters != null && filters.isNotEmpty) {
        _allApartments = await _apiService.searchApartments(_token!, filters: filters);
      } else {
        _allApartments = await _apiService.getAllApartments(_token!);
      }
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
      final all = await _apiService.getAllApartments(_token!);
      _featuredApartments = all.take(5).toList();
    } catch (e) {
      print('Failed to fetch featured apartments: $e');
    }
    notifyListeners();
  }

  Future<void> fetchMyApartments() async {
    if (_token == null || _userProvider?.user == null) return;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      // CORRECTED: The backend now has a dedicated endpoint for this
      _myApartments = await _apiService.getMyApartments(_token!);
      _status = ApartmentStatus.Loaded;
    } catch (e) {
      _status = ApartmentStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addApartment(Apartment apartment, List<XFile> images) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final apartmentData = {
        'title': apartment.title,
        'address': apartment.address!,
        'description': apartment.description ?? '',
        'city': apartment.city!,
        'governorate': apartment.governorate!,
        'price': apartment.price.toString(),
        'number_of_rooms': apartment.rooms.toString(),
        'area': apartment.area.toString(),
        'is_rented': (apartment.isRented ?? false).toString(),
      };

      final newApartment = await _apiService.createApartment(apartmentData, images, _token!);
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

  // --- SIMPLIFIED: This function now ONLY updates textual data ---
  Future<bool> updateApartment(Apartment apartment) async {
    if (_token == null) return false;
    _status = ApartmentStatus.Loading;
    notifyListeners();
    try {
      final detailsToUpdate = {
        'title': apartment.title,
        'address': apartment.address,
        'description': apartment.description,
        'city': apartment.city,
        'governorate': apartment.governorate,
        'price': apartment.price.toString(),
        'number_of_rooms': apartment.rooms.toString(),
        'area': apartment.area.toString(),
        'is_rented': apartment.isRented.toString(),
      };
      // Remove nulls so we only send updated values
      detailsToUpdate.removeWhere((key, value) => value == null);

      final updatedApartment = await _apiService.updateApartmentDetails(apartment.id, _token!, detailsToUpdate);

      // Refresh data locally
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
