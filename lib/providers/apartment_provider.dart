import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakani/models/apartment.dart';
import 'package:sakani/models/apartment_image.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/services/APIs/apartment_api_service.dart';

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
      if (filters == null || filters.isEmpty) {
        _allApartments = await _apiService.getAllApartments(_token!);
      } else {
        _allApartments = await _apiService.searchApartments(_token!, filters: filters);
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
        'address': apartment.address ?? '',
        'description': apartment.description ?? '',
        'city': apartment.city ?? '',
        'governorate': apartment.governorate ?? '',
        'price': apartment.price.toString(),
        'number_of_rooms': apartment.rooms?.toString() ?? '0',
        'area': apartment.area?.toString() ?? '0',
        'is_rented': apartment.isRented ? '1' : '0',
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
        'price': apartment.price,
        'number_of_rooms': apartment.rooms,
        'area': apartment.area,
        'is_rented': apartment.isRented,
      };
      detailsToUpdate.removeWhere((key, value) => value == null);

      final updatedApartment = await _apiService.updateApartmentDetails(apartment.id, _token!, detailsToUpdate);

      _updateLocalApartment(updatedApartment);
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

  Future<bool> uploadImageToApartment(int apartmentId, XFile image) async {
    if (_token == null) return false;
    try {
      final newImage = await _apiService.addApartmentImage(apartmentId, image, _token!);
      
      final apartment = _findLocalApartment(apartmentId);
      if (apartment != null) {
        final updatedImages = List<ApartmentImage>.from(apartment.images)..add(newImage);
        final updatedApartment = apartment.copyWith(images: updatedImages);
        _updateLocalApartment(updatedApartment);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeImageFromApartment(int apartmentId, int imageId) async {
    if (_token == null) return false;
    final apartment = _findLocalApartment(apartmentId);
    if (apartment == null) return false;

    final originalImages = List<ApartmentImage>.from(apartment.images);
    final updatedImages = List<ApartmentImage>.from(apartment.images)..removeWhere((img) => img.id == imageId);
    final updatedApartment = apartment.copyWith(images: updatedImages);
    _updateLocalApartment(updatedApartment);
    notifyListeners();

    try {
      await _apiService.deleteApartmentImages(apartmentId, [imageId], _token!);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      final revertedApartment = apartment.copyWith(images: originalImages);
      _updateLocalApartment(revertedApartment);
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

  Apartment? _findLocalApartment(int apartmentId) {
    try {
      return _allApartments.firstWhere((a) => a.id == apartmentId);
    } catch (e) {
      try {
        return _myApartments.firstWhere((a) => a.id == apartmentId);
      } catch (e) {
        return null;
      }
    }
  }

  void _updateLocalApartment(Apartment apartment) {
    final allIndex = _allApartments.indexWhere((a) => a.id == apartment.id);
    if (allIndex != -1) {
      _allApartments[allIndex] = apartment;
    }

    final myIndex = _myApartments.indexWhere((a) => a.id == apartment.id);
    if (myIndex != -1) {
      _myApartments[myIndex] = apartment;
    }
  }
}
