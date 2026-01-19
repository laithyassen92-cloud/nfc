import '../../../../core/http_client_helper.dart';
import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../../../core/api_constants.dart';
import '../../domain/models/student_wallet.dart';
import '../../domain/requests/student_wallet_config_request.dart';

class StudentWalletsDataSource {
  final HttpClientHelper httpClient;
  final String? authToken;

  StudentWalletsDataSource({required this.httpClient, this.authToken});

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<Either<Failure, StudentWallet>> getWalletByStudentId(
    int studentId,
  ) async {
    final result = await httpClient.get(
      '${ApiConstants.studentWalletsEndpoint}/student/$studentId',
      headers: _headers,
    );

    return result.map((data) => StudentWallet.fromJson(data));
  }

  Future<Either<Failure, StudentWallet>> getWalletById(int walletId) async {
    final result = await httpClient.get(
      '${ApiConstants.studentWalletsEndpoint}/$walletId',
      headers: _headers,
    );

    return result.map((data) => StudentWallet.fromJson(data));
  }

  Future<Either<Failure, StudentWallet>> updateWalletConfig(
    int walletId,
    StudentWalletConfigRequest request,
  ) async {
    final result = await httpClient.put(
      '${ApiConstants.studentWalletsEndpoint}/$walletId',
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => StudentWallet.fromJson(data));
  }

  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  }) async {
    final result = await httpClient.get(
      ApiConstants.studentWalletsEndpoint,
      headers: _headers,
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    return result.map((data) {
      final list = data['items'] as List? ?? data['data'] as List? ?? [];
      return list
          .map((item) => StudentWallet.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
