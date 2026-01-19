import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/failure.dart';
import '../../domain/repositories/student_wallets_repository.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/requests/student_wallet_config_request.dart';

// States
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final StudentWallet wallet;

  const WalletLoaded(this.wallet);

  @override
  List<Object?> get props => [wallet];
}

class WalletsListLoaded extends WalletState {
  final List<StudentWallet> wallets;

  const WalletsListLoaded(this.wallets);

  @override
  List<Object?> get props => [wallets];
}

class WalletError extends WalletState {
  final Failure failure;

  const WalletError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Cubit
class WalletCubit extends Cubit<WalletState> {
  final StudentWalletsRepository repository;

  WalletCubit({required this.repository}) : super(WalletInitial());

  Future<void> loadWalletByStudentId(int studentId) async {
    emit(WalletLoading());

    final result = await repository.getWalletByStudentId(studentId);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> loadWalletById(int walletId) async {
    emit(WalletLoading());

    final result = await repository.getWalletById(walletId);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> updateWalletConfig(
    int walletId,
    StudentWalletConfigRequest request,
  ) async {
    emit(WalletLoading());

    final result = await repository.updateWalletConfig(walletId, request);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> loadAllWallets({int page = 1, int pageSize = 20}) async {
    emit(WalletLoading());

    final result = await repository.getAllWallets(
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) => emit(WalletError(failure)),
      (wallets) => emit(WalletsListLoaded(wallets)),
    );
  }
}
