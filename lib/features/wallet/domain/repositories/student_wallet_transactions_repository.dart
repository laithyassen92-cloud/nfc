import '../../../../core/either.dart';
import '../../../../core/failure.dart';

import '../models/wallet_transaction.dart';
import '../requests/deposit_transaction_request.dart';
import '../requests/withdraw_transaction_request.dart';
import '../requests/refund_transaction_request.dart';

/// Repository interface for student wallet transaction operations
abstract class StudentWalletTransactionsRepository {
  /// Get transactions for a student
  Future<Either<Failure, List<WalletTransaction>>> getStudentTransactions({
    required String studentNumber,
    required int page,
    required int pageSize,
  });

  /// Create deposit transaction
  Future<Either<Failure, WalletTransaction>> deposit(
    DepositTransactionRequest request,
  );

  /// Create withdrawal transaction
  Future<Either<Failure, WalletTransaction>> withdraw(
    WithdrawTransactionRequest request,
  );

  /// Refund a transaction
  Future<Either<Failure, WalletTransaction>> refund(
    RefundTransactionRequest request,
  );
}
