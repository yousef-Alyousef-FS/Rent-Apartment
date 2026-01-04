import 'package:flutter/material.dart';
import 'package:plproject/models/review.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/services/APIs/review_api_service.dart';

enum ReviewStatus { Idle, Loading, Success, Error }

class ReviewProvider with ChangeNotifier {
  final ReviewApiService _apiService = ReviewApiService();
  UserProvider? _userProvider;

  ReviewStatus _status = ReviewStatus.Idle;
  String? _errorMessage;
  List<Review> _myReviews = [];

  ReviewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Review> get myReviews => _myReviews;

  void update(UserProvider userProvider) {
    _userProvider = userProvider;
  }

  String? get _token => _userProvider?.token;

  Future<bool> addReview({
    required int apartmentId,
    required int rating,
    required String comment,
  }) async {
    if (_token == null) {
      _errorMessage = 'You must be logged in to write a review.';
      return false;
    }

    _status = ReviewStatus.Loading;
    notifyListeners();

    try {
      await _apiService.addReview(
        token: _token!,
        apartmentId: apartmentId,
        rating: rating,
        comment: comment,
      );
      _status = ReviewStatus.Success;
      // Refresh the list of my reviews after adding a new one
      await fetchMyReviews(forceRefresh: true);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReviewStatus.Error;
      notifyListeners();
      return false;
    }
  }

  // --- NEW: Function to fetch the current user's reviews ---
  Future<void> fetchMyReviews({bool forceRefresh = false}) async {
    if (_token == null) return;
    if (_status == ReviewStatus.Loading && !forceRefresh) return;
    if (_myReviews.isNotEmpty && !forceRefresh) return;

    _status = ReviewStatus.Loading;
    notifyListeners();

    try {
      _myReviews = await _apiService.getMyReviews(_token!);
      _status = ReviewStatus.Success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = ReviewStatus.Error;
    }
    notifyListeners();
  }
}
