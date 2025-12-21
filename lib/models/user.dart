class User {
  int? id;
  String? first_name;
  String? last_name;
  DateTime? dateOfBirth;
  String? phone;
  String? profile_image;
  String? id_card_image;
  String? status;
  String? password;
  String? _token;

  String? get token => _token;
  set token(String? t) => _token = t;

  User({
    this.id,
    this.first_name,
    this.last_name,
    this.dateOfBirth,
    this.phone,
    this.profile_image,
    this.id_card_image,
    this.status,
    this.password,
    String? token,
  }) {
    _token = token;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      phone: json['phone'] as String?,
      profile_image: json['profile_image'] as String?,
      id_card_image: json['id_card_image'] as String?,
      status: json['status'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'profile_image': profile_image,
      'id_card_image': id_card_image,
      'status': status,
      'password': password,
    };
  }

  User copyWith({
    int? id,
    String? first_name,
    String? last_name,
    DateTime? dateOfBirth,
    String? phone,
    String? profile_image,
    String? id_card_image,
    String? status,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      profile_image: profile_image ?? this.profile_image,
      id_card_image: id_card_image ?? this.id_card_image,
      status: status ?? this.status,
      password: password ?? this.password,
      token: _token,
    );
  }

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  @override
  String toString() {
    return 'User(id: $id, name: $first_name $last_name, phone: $phone, status: $status, isAuthenticated: $isAuthenticated)';
  }
}
