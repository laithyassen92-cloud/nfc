class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }

  LoginRequest copyWith({String? username, String? password}) {
    return LoginRequest(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
