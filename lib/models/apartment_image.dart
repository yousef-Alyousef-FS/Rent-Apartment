class ApartmentImage {
  final int id;
  final String imageUrl;

  ApartmentImage({required this.id, required this.imageUrl});

  factory ApartmentImage.fromJson(Map<String, dynamic> json) {
    return ApartmentImage(
      id: json['id'],
      imageUrl: json['image_url'],
    );
  }
}
