import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/user.dart';

class Review {
  final int id;
  final int rating;
  final String comment;
  final User user;
  final Apartment apartment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
    required this.apartment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      // Assuming the backend nests user and apartment details within the review
      user: User.fromJson(json['user']),
      apartment: Apartment.fromJson(json['apartment']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
