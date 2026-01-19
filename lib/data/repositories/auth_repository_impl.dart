import '../../core/either.dart';
import '../../core/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/login_response.dart';
import '../../domain/requests/login_request.dart';
import '../../domain/requests/change_password_request.dart';
import '../../domain/requests/reset_password_request.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    final result = await dataSource.login(request);
    return result.fold((failure) {
      if (failure.statusCode == 401) {
        return Either.left(
          Failure.unauthorized('اسم المستخدم أو كلمة المرور غير صحيحة'),
        );
      }
      return Either.left(failure);
    }, (response) => Either.right(response));
  }

  @override
  Future<Either<Failure, void>> changePassword(ChangePasswordRequest request) {
    return dataSource.changePassword(request);
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequest request) {
    return dataSource.resetPassword(request);
  }

  @override
  Future<Either<Failure, void>> logout() {
    return dataSource.logout();
  }
}
