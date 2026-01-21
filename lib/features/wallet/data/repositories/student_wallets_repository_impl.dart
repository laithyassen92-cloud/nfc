import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../domain/repositories/student_wallets_repository.dart';
import '../../domain/models/student_wallet.dart';
import '../datasources/student_wallets_data_source.dart';

class StudentWalletsRepositoryImpl implements StudentWalletsRepository {
  final StudentWalletsDataSource dataSource;

  StudentWalletsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, StudentWallet>> getWalletDetails(
    String studentNumber,
  ) {
    return dataSource.getWalletDetails(studentNumber);
  }

  @override
  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  }) {
    return dataSource.getAllWallets(page: page, pageSize: pageSize);
  }
}
