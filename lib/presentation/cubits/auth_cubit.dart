import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/login_response.dart';
import '../../domain/requests/login_request.dart';
import '../../domain/requests/change_password_request.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserInfo user;
  final String token;

  const AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final Failure failure;

  const AuthError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    final request = LoginRequest(username: username, password: password);
    final result = await repository.login(request);

    result.fold(
      (failure) => emit(AuthError(failure)),
      (loginResponse) => emit(
        AuthAuthenticated(user: loginResponse.user, token: loginResponse.token),
      ),
    );
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    emit(AuthLoading());

    final result = await repository.changePassword(request);

    result.fold((failure) => emit(AuthError(failure)), (_) {
      // Keep the current authenticated state
      if (state is AuthAuthenticated) {
        emit(state);
      }
    });
  }

  void reset() {
    emit(AuthInitial());
  }

  void logout() {
    emit(AuthUnauthenticated());
  }
}
