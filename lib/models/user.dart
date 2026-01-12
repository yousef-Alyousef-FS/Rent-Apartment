class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? birthDate;
  final String? status;
  final String? profileImageUrl;
  final DateTime? createdAt;
  String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.birthDate,
    this.status,
    this.profileImageUrl,
    this.createdAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userData = json;
    if (json.containsKey('user')) {
      userData = json['user'] as Map<String, dynamic>;
    } else if (json.containsKey('user_data')) {
      userData = json['user_data'] as Map<String, dynamic>;
    }

    return User(
      id: userData['id'] as int? ?? 0,
      firstName: userData['first_name'] as String? ?? '',
      lastName: userData['last_name'] as String? ?? '',
      phone: userData['phone'] as String? ?? '',
      birthDate: userData['birth_date'] as String?,
      status: userData['status'] as String?,
      profileImageUrl: userData['profile_image_url'] as String?,
      createdAt: userData.containsKey('created_at') && userData['created_at'] != null
          ? DateTime.tryParse(userData['created_at'])
          : null,
      token: json['access_token'] as String? ?? json['token'] as String?,
    );
  }

  // --- NEW: toJson method to serialize the object ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'birth_date': birthDate,
      'status': status,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt?.toIso8601String(),
      'token': token,
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? birthDate,
    String? status,
    String? profileImageUrl,
    DateTime? createdAt,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      token: token ?? this.token,
    );
  }
}
