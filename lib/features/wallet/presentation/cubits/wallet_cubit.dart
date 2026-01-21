import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/student_wallets_repository.dart';
import '../../domain/repositories/student_wallet_transactions_repository.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/deposit_transaction_request.dart';
import '../../domain/requests/withdraw_transaction_request.dart';
import '../../domain/requests/refund_transaction_request.dart';

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

class WalletTransactionSuccess extends WalletState {
  final WalletTransaction transaction;

  const WalletTransactionSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionHistoryLoaded extends WalletState {
  final List<WalletTransaction> transactions;

  const TransactionHistoryLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class WalletError extends WalletState {
  final Failure failure;

  const WalletError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Cubit
class WalletCubit extends Cubit<WalletState> {
  final StudentWalletsRepository walletsRepository;
  final StudentWalletTransactionsRepository transactionsRepository;

  WalletCubit({
    required this.walletsRepository,
    required this.transactionsRepository,
  }) : super(WalletInitial());

  Future<void> getWalletDetails(String studentNumber) async {
    emit(WalletLoading());

    final result = await walletsRepository.getWalletDetails(studentNumber);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (wallet) => emit(WalletLoaded(wallet)),
    );
  }

  Future<void> getTransactions(
    String studentNumber, {
    int page = 1,
    int pageSize = 20,
  }) async {
    emit(WalletLoading());

    final result = await transactionsRepository.getStudentTransactions(
      studentNumber: studentNumber,
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) => emit(WalletError(failure)),
      (transactions) => emit(TransactionHistoryLoaded(transactions)),
    );
  }

  Future<void> deposit(DepositTransactionRequest request) async {
    emit(WalletLoading());

    final result = await transactionsRepository.deposit(request);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (transaction) => emit(WalletTransactionSuccess(transaction)),
    );
  }

  Future<void> withdraw(WithdrawTransactionRequest request) async {
    emit(WalletLoading());

    final result = await transactionsRepository.withdraw(request);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (transaction) => emit(WalletTransactionSuccess(transaction)),
    );
  }

  Future<void> refund(RefundTransactionRequest request) async {
    emit(WalletLoading());

    final result = await transactionsRepository.refund(request);

    result.fold(
      (failure) => emit(WalletError(failure)),
      (transaction) => emit(WalletTransactionSuccess(transaction)),
    );
  }
}
