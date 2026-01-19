import '../../core/http_client_helper.dart';
import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/api_constants.dart';
import '../../domain/models/login_response.dart';
import '../../domain/requests/login_request.dart';
import '../../domain/requests/change_password_request.dart';
import '../../domain/requests/reset_password_request.dart';

class AuthDataSource {
  final HttpClientHelper httpClient;
  final String? authToken;

  AuthDataSource({required this.httpClient, this.authToken});

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    final result = await httpClient.post(
      ApiConstants.loginEndpoint,
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => LoginResponse.fromJson(data));
  }

  Future<Either<Failure, void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    final result = await httpClient.post(
      ApiConstants.changePasswordEndpoint,
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((_) => null);
  }

  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final result = await httpClient.post(
      ApiConstants.resetPasswordEndpoint,
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((_) => null);
  }

  Future<Either<Failure, void>> logout() async {
    final result = await httpClient.post(
      ApiConstants.logoutEndpoint,
      body: {},
      headers: _headers,
    );

    return result.map((_) => null);
  }
}
