class Apartment
{
    final int id;
    final int userId;
    final String title;
    final String description;
    final double price;
    final bool isRented;
    final String? address;
    final String? city;
    final String? governorate;
    final int? rooms;
    final int? area;
    final List<String> imageUrls;
    final double? average_rating;
    final int? reviews_count;

    Apartment({
        required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.price,
        required this.isRented,
        this.address,
        this.city,
        this.governorate,
        this.rooms,
        this.area,

        required this.imageUrls,
        this.average_rating,
        this.reviews_count
    });

    factory Apartment.fromJson(Map<String, dynamic> json)
    {
        return Apartment(
            id: json['id'] as int,
            userId: json['user_id'] as int? ?? 0, // Fallback for safety
            title: json['title'] as String? ?? 'Untitled Apartment',
            description: json['description'] as String,
            price: (json['price'] as num).toDouble(),
            isRented: (json['is_rented'] as int? ?? 0) == 1,
            address: json['address'] as String?,
            city: json['city'] as String?,
            governorate: json['governorate'] as String?,
            rooms: json['number_of_rooms'] as int?,
            area: json['area'] as int?,
            imageUrls: json['images'] != null
                ? List<String>.from(json['images'].map((img) => img['image_url']))
                : [],
            average_rating: (json['average_rating'] as num?)?.toDouble(),
            reviews_count: json['reviews_count'] as int?
        );
    }

    Map<String, dynamic> toJson()
    {
        return
        {
            'id': id,
            'user_id': userId, 'title': title,
            'description': description,
            'price': price,
            'is_rented': isRented ? 1 : 0,
            'address': address,
            'city': city,
            'governorate': governorate,
            'number_of_rooms': rooms,
            'area': area
            // 'image_urls' is usually handled separately via file uploads,
            // so it's not included in the main JSON body.

        };
    }

    // --- UPDATED: Full copyWith implementation ---
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
        List<String>? imageUrls,
        double? average_rating,
        int? reviews_count
    })
    {
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
            imageUrls: imageUrls ?? this.imageUrls,
            average_rating: average_rating ?? this.average_rating,
            reviews_count: reviews_count ?? this.reviews_count
        );
    }
}
