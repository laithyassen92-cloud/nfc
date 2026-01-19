class RegisterFirebaseTokenRequest {
  final String firebaseToken;
  final String deviceId;
  final String? platform; // iOS, Android, Web

  RegisterFirebaseTokenRequest({
    required this.firebaseToken,
    required this.deviceId,
    this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseToken': firebaseToken,
      'deviceId': deviceId,
      if (platform != null) 'platform': platform,
    };
  }

  factory RegisterFirebaseTokenRequest.fromJson(Map<String, dynamic> json) {
    return RegisterFirebaseTokenRequest(
      firebaseToken: json['firebaseToken'] as String,
      deviceId: json['deviceId'] as String,
      platform: json['platform'] as String?,
    );
  }

  RegisterFirebaseTokenRequest copyWith({
    String? firebaseToken,
    String? deviceId,
    String? platform,
  }) {
    return RegisterFirebaseTokenRequest(
      firebaseToken: firebaseToken ?? this.firebaseToken,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
    );
  }
}
