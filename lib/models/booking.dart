import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/user.dart';

class Booking {
  final int id;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final String status; // e.g., 'pending_approval', 'confirmed', 'cancelled', 'completed'

  final Apartment apartment;
  final User user;

  Booking({
    required this.id,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.apartment,
    required this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      checkInDate: DateTime.parse(json['check_in_date'] as String),
      checkOutDate: DateTime.parse(json['check_out_date'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      apartment: Apartment.fromJson(json['apartment'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'apartment_id': apartment.id, // Usually we only send the ID
      'user_id': user.id,
    };
  }

  Booking copyWith({
    int? id,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    double? totalPrice,
    String? status,
    Apartment? apartment,
    User? user,
  }) {
    return Booking(
      id: id ?? this.id,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      apartment: apartment ?? this.apartment,
      user: user ?? this.user,
    );
  }
}
