import '../../core/either.dart';
import '../../core/failure.dart';
import '../models/student_wallet.dart';
import '../requests/student_wallet_config_request.dart';

/// Repository interface for student wallet operations
abstract class StudentWalletsRepository {
  /// Get wallet by student ID
  Future<Either<Failure, StudentWallet>> getWalletByStudentId(int studentId);

  /// Get wallet by ID
  Future<Either<Failure, StudentWallet>> getWalletById(int walletId);

  /// Update wallet configuration
  Future<Either<Failure, StudentWallet>> updateWalletConfig(
    int walletId,
    StudentWalletConfigRequest request,
  );

  /// Get all wallets (paginated)
  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  });
}
