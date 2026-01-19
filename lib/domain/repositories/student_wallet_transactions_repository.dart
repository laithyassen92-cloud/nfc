import '../../core/either.dart';
import '../../core/failure.dart';
import '../models/wallet_transaction.dart';
import '../requests/deposit_transaction_request.dart';
import '../requests/withdraw_transaction_request.dart';
import '../requests/refund_transaction_request.dart';

/// Repository interface for student wallet transaction operations
abstract class StudentWalletTransactionsRepository {
  /// Get transactions for a wallet
  Future<Either<Failure, List<WalletTransaction>>> getTransactionsByWalletId({
    required int walletId,
    required int page,
    required int pageSize,
  });

  /// Get transaction by ID
  Future<Either<Failure, WalletTransaction>> getTransactionById(int id);

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

  /// Get all transactions (paginated)
  Future<Either<Failure, List<WalletTransaction>>> getAllTransactions({
    required int page,
    required int pageSize,
  });
}
