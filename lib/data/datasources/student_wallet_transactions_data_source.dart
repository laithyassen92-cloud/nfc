import '../../core/http_client_helper.dart';
import '../../core/either.dart';
import '../../core/failure.dart';
import '../../core/api_constants.dart';
import '../../domain/models/wallet_transaction.dart';
import '../../domain/requests/deposit_transaction_request.dart';
import '../../domain/requests/withdraw_transaction_request.dart';
import '../../domain/requests/refund_transaction_request.dart';

class StudentWalletTransactionsDataSource {
  final HttpClientHelper httpClient;
  final String? authToken;

  StudentWalletTransactionsDataSource({
    required this.httpClient,
    this.authToken,
  });

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

  Future<Either<Failure, List<WalletTransaction>>> getTransactionsByWalletId({
    required int walletId,
    required int page,
    required int pageSize,
  }) async {
    final result = await httpClient.get(
      '${ApiConstants.studentWalletTransactionsEndpoint}/wallet/$walletId',
      headers: _headers,
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    return result.map((data) {
      final list = data['items'] as List? ?? data['data'] as List? ?? [];
      return list
          .map(
            (item) => WalletTransaction.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Future<Either<Failure, WalletTransaction>> getTransactionById(int id) async {
    final result = await httpClient.get(
      '${ApiConstants.studentWalletTransactionsEndpoint}/$id',
      headers: _headers,
    );

    return result.map((data) => WalletTransaction.fromJson(data));
  }

  Future<Either<Failure, WalletTransaction>> deposit(
    DepositTransactionRequest request,
  ) async {
    final result = await httpClient.post(
      '${ApiConstants.studentWalletTransactionsEndpoint}/deposit',
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => WalletTransaction.fromJson(data));
  }

  Future<Either<Failure, WalletTransaction>> withdraw(
    WithdrawTransactionRequest request,
  ) async {
    final result = await httpClient.post(
      '${ApiConstants.studentWalletTransactionsEndpoint}/withdraw',
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => WalletTransaction.fromJson(data));
  }

  Future<Either<Failure, WalletTransaction>> refund(
    RefundTransactionRequest request,
  ) async {
    final result = await httpClient.post(
      '${ApiConstants.studentWalletTransactionsEndpoint}/refund',
      body: request.toJson(),
      headers: _headers,
    );

    return result.map((data) => WalletTransaction.fromJson(data));
  }

  Future<Either<Failure, List<WalletTransaction>>> getAllTransactions({
    required int page,
    required int pageSize,
  }) async {
    final result = await httpClient.get(
      ApiConstants.studentWalletTransactionsEndpoint,
      headers: _headers,
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    return result.map((data) {
      final list = data['items'] as List? ?? data['data'] as List? ?? [];
      return list
          .map(
            (item) => WalletTransaction.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });
  }
}
