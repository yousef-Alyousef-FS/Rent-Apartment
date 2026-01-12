import 'package:sakani/models/apartment_image.dart';

class Apartment {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final double price;
  final bool isRented;
  final String? address;
  final String? city;
  final String? governorate;
  final int? rooms;
  final int? area;
  final List<ApartmentImage> images;
  final double? average_rating;
  final int? reviews_count;

  Apartment({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.price,
    required this.isRented,
    this.address,
    this.city,
    this.governorate,
    this.rooms,
    this.area,
    required this.images,
    this.average_rating,
    this.reviews_count,
  });

  // --- REBUILT: To be robust against all data type inconsistencies from the API ---
  factory Apartment.fromJson(Map<String, dynamic> json) {
    double? safeDoubleParse(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? safeIntParse(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is double) return value.toInt();
      return null;
    }

    bool parseIsRented(dynamic value) {
        if (value is bool) return value;
        if (value is int) return value == 1;
        if (value is String) return value == '1' || value.toLowerCase() == 'true';
        return false;
    }
    
    var imagesData = json['imageUrls'] ?? json['images'];

    return Apartment(
      id: safeIntParse(json['id']) ?? 0,
      userId: safeIntParse(json['userId'] ?? json['user_id']) ?? 0,
      title: json['title'] as String? ?? 'Untitled Apartment',
      description: json['description'] as String?,
      price: safeDoubleParse(json['price']) ?? 0.0,
      isRented: parseIsRented(json['isRented']),
      address: json['address'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      rooms: safeIntParse(json['rooms'] ?? json['number_of_rooms']),
      area: safeIntParse(json['area']),
      images: imagesData != null && imagesData is List
          ? (imagesData as List).map((i) => ApartmentImage.fromJson(i)).toList()
          : [],
      average_rating: safeDoubleParse(json['average_rating']),
      reviews_count: safeIntParse(json['reviews_count']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'price': price,
      'is_rented': isRented ? 1 : 0,
      'address': address,
      'city': city,
      'governorate': governorate,
      'number_of_rooms': rooms,
      'area': area,
    };
  }

  Apartment copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    double? price,
    bool? isRented,
    String? address,
    String? city,
    String? governorate,
    int? rooms,
    int? area,
    List<ApartmentImage>? images,
    double? average_rating,
    int? reviews_count,
  }) {
    return Apartment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isRented: isRented ?? this.isRented,
      address: address ?? this.address,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      rooms: rooms ?? this.rooms,
      area: area ?? this.area,
      images: images ?? this.images,
      average_rating: average_rating ?? this.average_rating,
      reviews_count: reviews_count ?? this.reviews_count,
    );
  }
}
