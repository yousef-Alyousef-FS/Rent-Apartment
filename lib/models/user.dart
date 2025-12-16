class User {
  int? id;
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;
  String? phone;
  String? personalImagePath;
  String? idCardImagePath;
  String? _token;

  String? get token => _token;
  set token(String? t) => _token;

  User({
    this.id,
    this.firstName, this.lastName,
    this.dateOfBirth, this.phone,
    this.personalImagePath, this.idCardImagePath
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      phone: json['phone'] as String?,
      personalImagePath: json['personalImagePath'] as String?,
      idCardImagePath: json['idCardImagePath'] as String?,
    );

    user._token = json['token'] as String?;
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'personalImagePath': personalImagePath,
      'idCardImagePath': idCardImagePath,
    };
  }

  Map<String, dynamic> toJsonWithToken() {
    return {
      'user': toJson(),
      'token': _token
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? phone,
    String? personalImagePath,
    String? idCardImagePath,
  }) {
    final newUser = User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      personalImagePath: personalImagePath ?? this.personalImagePath,
      idCardImagePath: idCardImagePath ?? this.idCardImagePath,
    );
    newUser._token = _token;
    return newUser;
  }
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  @override
  String toString() {
    return 'User(id: $id, name: $firstName $lastName, phone: $phone, isAuthenticated: $isAuthenticated)';
  }
}