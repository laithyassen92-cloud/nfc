class LoginResponse {
  final String token;
  final String refreshToken;
  final UserInfo user;
  final DateTime expiresAt;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  LoginResponse copyWith({
    String? token,
    String? refreshToken,
    UserInfo? user,
    DateTime? expiresAt,
  }) {
    return LoginResponse(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class UserInfo {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // Admin, Teacher, Guardian, etc.
  final String? photoUrl;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.photoUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  String get fullName => '$firstName $lastName';

  UserInfo copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? role,
    String? photoUrl,
  }) {
    return UserInfo(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
