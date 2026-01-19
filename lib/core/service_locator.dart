import 'package:http/http.dart' as http;
import '../../core/http_client_helper.dart';
import '../../core/api_constants.dart';
import '../features/auth/data/datasources/auth_data_source.dart';
import '../features/students/data/datasources/students_data_source.dart';
import '../features/wallet/data/datasources/student_wallets_data_source.dart';
import '../features/wallet/data/datasources/student_wallet_transactions_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/students/data/repositories/students_repository_impl.dart';
import '../features/wallet/data/repositories/student_wallets_repository_impl.dart';
import '../features/wallet/data/repositories/student_wallet_transactions_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/students/domain/repositories/students_repository.dart';
import '../features/wallet/domain/repositories/student_wallets_repository.dart';
import '../features/wallet/domain/repositories/student_wallet_transactions_repository.dart';
import '../features/auth/presentation/cubits/auth_cubit.dart';
import '../features/students/presentation/cubits/students_cubit.dart';
import '../features/wallet/presentation/cubits/wallet_cubit.dart';
import '../features/wallet/presentation/cubits/transactions_cubit.dart';

/// Service Locator for Dependency Injection
/// This is a simple implementation. For larger apps, consider using get_it package
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // HTTP Client
  late final HttpClientHelper _httpClient;

  // Auth token storage (in production, use secure storage)
  String? _authToken;

  void initialize() {
    _httpClient = HttpClientHelper(
      client: http.Client(),
      baseUrl: ApiConstants.baseUrl,
      timeout: ApiConstants.connectionTimeout,
    );
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  String? get authToken => _authToken;

  // Data Sources
  AuthDataSource get authDataSource =>
      AuthDataSource(httpClient: _httpClient, authToken: _authToken);

  StudentsDataSource get studentsDataSource =>
      StudentsDataSource(httpClient: _httpClient, authToken: _authToken);

  StudentWalletsDataSource get studentWalletsDataSource =>
      StudentWalletsDataSource(httpClient: _httpClient, authToken: _authToken);

  StudentWalletTransactionsDataSource get studentWalletTransactionsDataSource =>
      StudentWalletTransactionsDataSource(
        httpClient: _httpClient,
        authToken: _authToken,
      );

  // Repositories
  AuthRepository get authRepository =>
      AuthRepositoryImpl(dataSource: authDataSource);

  StudentsRepository get studentsRepository =>
      StudentsRepositoryImpl(dataSource: studentsDataSource);

  StudentWalletsRepository get studentWalletsRepository =>
      StudentWalletsRepositoryImpl(dataSource: studentWalletsDataSource);

  StudentWalletTransactionsRepository get studentWalletTransactionsRepository =>
      StudentWalletTransactionsRepositoryImpl(
        dataSource: studentWalletTransactionsDataSource,
      );

  // Cubits
  AuthCubit get authCubit => AuthCubit(repository: authRepository);

  StudentsCubit get studentsCubit =>
      StudentsCubit(repository: studentsRepository);

  WalletCubit get walletCubit =>
      WalletCubit(repository: studentWalletsRepository);

  TransactionsCubit get transactionsCubit =>
      TransactionsCubit(repository: studentWalletTransactionsRepository);

  void dispose() {
    _httpClient.close();
  }
}
