class LoginResponse {
  final String token; // accessToken من الـ API
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
    String? getString(String key) {
      final val = json[key];
      if (val == null) return null;
      return val as String;
    }

    final token = getString('accessToken');
    final refreshToken = getString('refreshToken');
    final userJson = json['userInfo'] as Map<String, dynamic>?;
    final expiresAtString = getString('expiryAccessToken');

    if (token == null) {
      throw FormatException('Missing required field: accessToken in $json');
    }
    if (refreshToken == null) {
      throw FormatException('Missing required field: refreshToken in $json');
    }
    if (userJson == null) {
      throw FormatException('Missing required field: userInfo in $json');
    }
    if (expiresAtString == null) {
      throw FormatException(
        'Missing required field: expiryAccessToken in $json',
      );
    }

    return LoginResponse(
      token: token,
      refreshToken: refreshToken,
      user: UserInfo.fromJson(userJson),
      expiresAt: DateTime.parse(expiresAtString),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': token,
      'refreshToken': refreshToken,
      'userInfo': user.toJson(),
      'expiryAccessToken': expiresAt.toIso8601String(),
    };
  }
}
class UserInfo {
  final String id; // UUID
  final String fullName;
  final String email;
  final int role;
  final String? username;
  final String? photoUrl;

  UserInfo({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.username,
    this.photoUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    String? getString(String key) {
      final val = json[key];
      if (val == null) return null;
      return val.toString();
    }

    int? getInt(String key) {
      final val = json[key];
      if (val == null) return null;
      if (val is int) return val;
      return int.tryParse(val.toString());
    }

    final id = getString('id');
    final fullName = getString('fullName');
    final email = getString('email');
    final role = getInt('role');

    if (id == null) {
      throw FormatException('Missing required field: id in UserInfo $json');
    }
    if (fullName == null) {
      throw FormatException(
        'Missing required field: fullName in UserInfo $json',
      );
    }
    if (email == null) {
      throw FormatException(
        'Missing required field: email in UserInfo $json',
      );
    }
    if (role == null) {
      throw FormatException('Missing required field: role in UserInfo $json');
    }

    return UserInfo(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      username: getString('username'),
      photoUrl: getString('profilePhotoUrl'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      if (username != null) 'username': username,
      if (photoUrl != null) 'profilePhotoUrl': photoUrl,
    };
  }
}
