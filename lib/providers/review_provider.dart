import 'package:flutter/material.dart';
import 'package:plproject/models/review.dart';
import 'package:plproject/services/APIs/review_api_service.dart';

enum ReviewStatus {
  Idle,
  Loading,
  Loaded,
  Error
}

class ReviewProvider with ChangeNotifier {
  final ReviewApiService _apiService = ReviewApiService();

  ReviewStatus _status = ReviewStatus.Idle;
  List<Review> _reviews = [];
  String? _errorMessage;

  // Getters
  ReviewStatus get status => _status;
  List<Review> get reviews => _reviews;
  String? get errorMessage => _errorMessage;

  Future<void> fetchApartmentReviews(int apartmentId) async {
    _status = ReviewStatus.Loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _reviews = await _apiService.getReviews(apartmentId);
      _status = ReviewStatus.Loaded;
    } catch (e) {
      _status = ReviewStatus.Error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> addReview(int apartmentId, String token, {required int rating, required String comment}) async {
    _status = ReviewStatus.Loading;
    notifyListeners();
    try {
      final newReview = await _apiService.addReview(apartmentId, token, rating: rating, comment: comment);
      _reviews.insert(0, newReview); // Add the new review to the top of the list
      _status = ReviewStatus.Loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReviewStatus.Error;
      notifyListeners();
      return false;
    }
  }
}
