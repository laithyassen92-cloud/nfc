import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/student_wallet_transactions_repository.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/deposit_transaction_request.dart';
import '../../domain/requests/withdraw_transaction_request.dart';
import '../../domain/requests/refund_transaction_request.dart';

// States
abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<WalletTransaction> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionDetailsLoaded extends TransactionsState {
  final WalletTransaction transaction;

  const TransactionDetailsLoaded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionsError extends TransactionsState {
  final Failure failure;

  const TransactionsError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// Cubit
class TransactionsCubit extends Cubit<TransactionsState> {
  final StudentWalletTransactionsRepository repository;

  TransactionsCubit({required this.repository}) : super(TransactionsInitial());

  Future<void> loadTransactions({
    required String studentNumber,
    int page = 1,
    int pageSize = 20,
  }) async {
    emit(TransactionsLoading());

    final result = await repository.getStudentTransactions(
      studentNumber: studentNumber,
      page: page,
      pageSize: pageSize,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure)),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }

  Future<void> deposit(DepositTransactionRequest request) async {
    emit(TransactionsLoading());

    final result = await repository.deposit(request);

    result.fold(
      (failure) => emit(TransactionsError(failure)),
      (transaction) => emit(TransactionDetailsLoaded(transaction)),
    );
  }

  Future<void> withdraw(WithdrawTransactionRequest request) async {
    emit(TransactionsLoading());

    final result = await repository.withdraw(request);

    result.fold(
      (failure) => emit(TransactionsError(failure)),
      (transaction) => emit(TransactionDetailsLoaded(transaction)),
    );
  }

  Future<void> refund(RefundTransactionRequest request) async {
    emit(TransactionsLoading());

    final result = await repository.refund(request);

    result.fold(
      (failure) => emit(TransactionsError(failure)),
      (transaction) => emit(TransactionDetailsLoaded(transaction)),
    );
  }
}
