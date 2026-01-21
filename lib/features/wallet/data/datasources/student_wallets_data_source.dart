import '../../../../core/http_client_helper.dart';
import '../../../../core/either.dart';
import '../../../../core/failure.dart';
import '../../../../core/api_constants.dart';
import '../../domain/models/student_wallet.dart';

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

  Future<Either<Failure, StudentWallet>> getWalletDetails(
    String studentNumber,
  ) async {
    final result = await httpClient.get(
      ApiConstants.walletDetails,
      headers: _headers,
      queryParameters: {'studentNumber': studentNumber},
    );

    return result.map((data) => StudentWallet.fromJson(data));
  }

  Future<Either<Failure, List<StudentWallet>>> getAllWallets({
    required int page,
    required int pageSize,
  }) async {
    final result = await httpClient.get(
      ApiConstants
          .walletDetails, // getAllWallets might not exist, using walletDetails for now per context
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
