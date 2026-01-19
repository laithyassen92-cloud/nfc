import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/student_wallets_repository.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/requests/student_wallet_config_request.dart';
import '../datasources/student_wallets_data_source.dart';

class StudentWalletsRepositoryImpl implements StudentWalletsRepository {
  final StudentWalletsDataSource dataSource;

  StudentWalletsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, StudentWallet>> getWalletByStudentId(int studentId) {
    return dataSource.getWalletByStudentId(studentId);
  }

  @override
  Future<Either<Failure, StudentWallet>> getWalletById(int walletId) {
    return dataSource.getWalletById(walletId);
  }

  @override
  Future<Either<Failure, StudentWallet>> updateWalletConfig(
    int walletId,
    StudentWalletConfigRequest request,
  ) {
    return dataSource.updateWalletConfig(walletId, request);
  }

  @override
  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  }) {
    return dataSource.getAllWallets(page: page, pageSize: pageSize);
  }
}
