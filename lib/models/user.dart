class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String? birthDate;
  final String? status;
  final String? profileImageUrl; // CORRECTED: Handles displayable URL from backend
  String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.birthDate,
    this.status,
    this.profileImageUrl,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // The user data might be nested inside a 'user' key from the login/register response
    final userData = json.containsKey('user') ? json['user'] as Map<String, dynamic> : json;

    return User(
      id: userData['id'] as int,
      firstName: userData['first_name'] as String,
      lastName: userData['last_name'] as String,
      phone: userData['phone'] as String,
      birthDate: userData['birth_date'] as String?,
      status: userData['status'] as String?,
      // CORRECTED: Reads the 'profile_image_url' key provided by the backend
      profileImageUrl: userData['profile_image_url'] as String?,
      // Token is usually at the top level of the response, not inside the 'user' object
      token: json['access_token'] as String?,
    );
  }

  // Helper method to update parts of the user object
  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? birthDate,
    String? status,
    String? profileImageUrl,
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
      token: token ?? this.token,
    );
  }
}
