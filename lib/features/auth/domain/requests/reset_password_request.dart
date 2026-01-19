class ResetPasswordRequest {
  final String email;
  final String resetCode;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.resetCode,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'resetCode': resetCode,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      email: json['email'] as String,
      resetCode: json['resetCode'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );
  }

  ResetPasswordRequest copyWith({
    String? email,
    String? resetCode,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ResetPasswordRequest(
      email: email ?? this.email,
      resetCode: resetCode ?? this.resetCode,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
