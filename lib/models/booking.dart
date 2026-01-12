import 'package:sakani/models/apartment.dart';
import 'package:sakani/models/user.dart';

class Booking {
  final int id;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final String status;
  final Apartment? apartment;
  final User? user;

  Booking({
    required this.id,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    this.apartment,
    this.user,
  });

  // --- REBUILT: To handle multiple response structures from the backend ---
  factory Booking.fromJson(Map<String, dynamic> json) {
    // Helper for safe parsing of price, which might be a string or a num
    double safeDoubleParse(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return Booking(
      id: json['id'] as int,
      // Handle both date formats from the server ('start_date' or 'check_in_date')
      checkInDate: DateTime.parse((json['start_date'] ?? json['check_in_date']) as String),
      checkOutDate: DateTime.parse((json['end_date'] ?? json['check_out_date']) as String),
      totalPrice: safeDoubleParse(json['total_price'] ?? '0.0'),
      status: (json['status'] ?? 'pending').toString(),
      // Safely parse nested objects, creating them only if they exist in the JSON
      apartment: json.containsKey('apartment') && json['apartment'] != null
          ? Apartment.fromJson(json['apartment'] as Map<String, dynamic>)
          : null,
      user: json.containsKey('user') && json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'apartment_id': apartment?.id,
      'user_id': user?.id,
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
