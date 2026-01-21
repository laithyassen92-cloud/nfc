import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/student_wallet_transactions_repository.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/deposit_transaction_request.dart';
import '../../domain/requests/withdraw_transaction_request.dart';
import '../../domain/requests/refund_transaction_request.dart';
import '../datasources/student_wallet_transactions_data_source.dart';

class StudentWalletTransactionsRepositoryImpl
    implements StudentWalletTransactionsRepository {
  final StudentWalletTransactionsDataSource dataSource;

  StudentWalletTransactionsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<WalletTransaction>>> getStudentTransactions({
    required String studentNumber,
    required int page,
    required int pageSize,
  }) {
    return dataSource.getStudentTransactions(
      studentNumber: studentNumber,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Either<Failure, WalletTransaction>> deposit(
    DepositTransactionRequest request,
  ) {
    return dataSource.deposit(request);
  }

  @override
  Future<Either<Failure, WalletTransaction>> withdraw(
    WithdrawTransactionRequest request,
  ) {
    return dataSource.withdraw(request);
  }

  @override
  Future<Either<Failure, WalletTransaction>> refund(
    RefundTransactionRequest request,
  ) {
    return dataSource.refund(request);
  }
}
