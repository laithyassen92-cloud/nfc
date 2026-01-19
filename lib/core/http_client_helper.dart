import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'failure.dart';
import 'either.dart';

class HttpClientHelper {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  HttpClientHelper({
    http.Client? client,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  // GET request
  Future<Either<Failure, Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      final response = await _client
          .get(uri, headers: headers)
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      return Either.left(Failure.network());
    } on TimeoutException {
      return Either.left(Failure.timeout());
    } catch (e) {
      return Either.left(Failure.unknown(e.toString()));
    }
  }

  // POST request
  Future<Either<Failure, Map<String, dynamic>>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      return Either.left(Failure.network());
    } on TimeoutException {
      return Either.left(Failure.timeout());
    } catch (e) {
      return Either.left(Failure.unknown(e.toString()));
    }
  }

  // PUT request
  Future<Either<Failure, Map<String, dynamic>>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      final response = await _client
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      return Either.left(Failure.network());
    } on TimeoutException {
      return Either.left(Failure.timeout());
    } catch (e) {
      return Either.left(Failure.unknown(e.toString()));
    }
  }

  // DELETE request
  Future<Either<Failure, Map<String, dynamic>>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);

      final response = await _client
          .delete(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      return Either.left(Failure.network());
    } on TimeoutException {
      return Either.left(Failure.timeout());
    } catch (e) {
      return Either.left(Failure.unknown(e.toString()));
    }
  }

  // Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final url = baseUrl + endpoint;
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return Uri.parse(url).replace(queryParameters: queryParameters);
    }
    return Uri.parse(url);
  }

  // Handle HTTP response
  Either<Failure, Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) {
    try {
      final statusCode = response.statusCode;

      // Success responses (200-299)
      if (statusCode >= 200 && statusCode < 300) {
        if (response.body.isEmpty) {
          return Either.right({});
        }

        final Map<String, dynamic> data = jsonDecode(response.body);
        return Either.right(data);
      }

      // Parse error response
      Map<String, dynamic>? errorData;
      if (response.body.isNotEmpty) {
        try {
          errorData = jsonDecode(response.body);
        } catch (_) {
          // If JSON parsing fails, use response body as message
        }
      }

      final errorMessage =
          errorData?['message'] as String? ??
          errorData?['error'] as String? ??
          errorData?['detail'] as String? ?? // RFC 7807 detail
          errorData?['title'] as String? ?? // RFC 7807 title
          response.body;

      // Handle specific status codes
      switch (statusCode) {
        case 400:
          return Either.left(Failure.validation(errorMessage, errorData));
        case 401:
          return Either.left(Failure.unauthorized(errorMessage));
        case 403:
          return Either.left(Failure.forbidden(errorMessage));
        case 404:
          return Either.left(Failure.notFound(errorMessage));
        case 500:
        case 502:
        case 503:
          return Either.left(Failure.server(errorMessage, statusCode));
        default:
          return Either.left(Failure.server(errorMessage, statusCode));
      }
    } catch (e) {
      return Either.left(
        Failure.parse('Failed to parse response: ${e.toString()}'),
      );
    }
  }

  // Close the client
  void close() {
    _client.close();
  }
}
