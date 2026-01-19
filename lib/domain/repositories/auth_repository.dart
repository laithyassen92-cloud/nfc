import '../../core/either.dart';
import '../../core/failure.dart';
import '../models/login_response.dart';
import '../requests/login_request.dart';
import '../requests/change_password_request.dart';
import '../requests/reset_password_request.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with username and password
  Future<Either<Failure, LoginResponse>> login(LoginRequest request);

  /// Change password for authenticated user
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request);

  /// Reset password (forgot password flow)
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request);

  /// Logout (if needed for server-side logout)
  Future<Either<Failure, void>> logout();
}
