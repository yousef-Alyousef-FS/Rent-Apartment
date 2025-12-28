class User {
  final int? id;
  final String? first_name; // Made nullable
  final String? last_name;  // Made nullable
  final String? phone;
  final String? password; 
  final String? profile_image;
  final String? id_card_image;
  final String? dateOfBirth;
  String? status;
  String? token;

  User({
    this.id,
    this.first_name, // No longer required
    this.last_name,  // No longer required
    this.phone,
    this.password,
    this.profile_image,
    this.id_card_image,
    this.dateOfBirth,
    this.status,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      token: json['token'] as String?,
      profile_image: json['profile_image_url'] as String?,
      dateOfBirth: json['birth_date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (first_name != null) data['first_name'] = first_name;
    if (last_name != null) data['last_name'] = last_name;
    if (phone != null) data['phone'] = phone;
    if (password != null) data['password'] = password;
    if (profile_image != null) data['profile_image_url'] = profile_image;
    if (id_card_image != null) data['id_card_image_url'] = id_card_image;
    if (dateOfBirth != null) data['birth_date'] = dateOfBirth;
    return data;
  }

  User copyWith({
    int? id,
    String? first_name,
    String? last_name,
    String? phone,
    String? password,
    String? profile_image,
    String? id_card_image,
    String? dateOfBirth,
    String? status,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profile_image: profile_image ?? this.profile_image,
      id_card_image: id_card_image ?? this.id_card_image,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }
}
