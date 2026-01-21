import '../../../../core/either.dart';
import '../../../../core/failure.dart';

import '../models/student_wallet.dart';

/// Repository interface for student wallet operations
abstract class StudentWalletsRepository {
  /// Get wallet details by student Number
  Future<Either<Failure, StudentWallet>> getWalletDetails(String studentNumber);

  /// Get all wallets
  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  });
}
