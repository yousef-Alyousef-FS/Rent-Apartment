import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/review.dart';
import 'package:plproject/settings/connection.dart';

class ReviewApiService {
  static const String _baseUrl = Connection.emulator_baseUrl;

  Future<void> addReview({
    required String token,
    required int apartmentId,
    required int rating,
    required String comment,
  }) async {
    final uri = Uri.parse('$_baseUrl/apartments/$apartmentId/reviews');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode != 201) {
      final errorBody = jsonDecode(response.body);
      final message = errorBody['message'] ?? 'Failed to submit review.';
      throw Exception(message);
    }
  }

  // --- NEW: Function to get the current user's reviews ---
  Future<List<Review>> getMyReviews(String token) async {
    final uri = Uri.parse('$_baseUrl/my-reviews');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my reviews: ${response.body}');
    }
  }
}
