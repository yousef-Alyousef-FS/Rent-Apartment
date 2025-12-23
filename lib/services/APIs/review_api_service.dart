import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plproject/models/review.dart';

import '../../settings/connection.dart';

class ReviewApiService {
  final String _baseUrl = Connection.emulatorBaseUrl ;

  // Fetches all reviews for a specific apartment
  Future<List<Review>> getReviews(int apartmentId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/apartments/$apartmentId/reviews'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews. Status: ${response.statusCode}');
    }
  }

  // Adds a new review to a specific apartment
  Future<Review> addReview(int apartmentId, String token, {required int rating, required String comment}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/apartments/$apartmentId/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
