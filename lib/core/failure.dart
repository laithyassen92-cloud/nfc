import 'package:equatable/equatable.dart';

/// Represents different types of failures that can occur in the application
class Failure extends Equatable {
  final String message;
  final Map<String, dynamic>? data;
  final int? statusCode;
  final FailureType type;

  const Failure({
    required this.message,
    required this.type,
    this.data,
    this.statusCode,
  });

  // Network failure (no internet connection)
  factory Failure.network([String? message]) {
    return Failure(
      message: message ?? 'لا يوجد اتصال بالإنترنت',
      type: FailureType.network,
    );
  }

  // Timeout failure
  factory Failure.timeout([String? message]) {
    return Failure(
      message: message ?? 'انتهت مهلة الاتصال',
      type: FailureType.timeout,
    );
  }

  // Validation failure (400 Bad Request)
  factory Failure.validation(String message, [Map<String, dynamic>? data]) {
    return Failure(
      message: message,
      type: FailureType.validation,
      data: data,
      statusCode: 400,
    );
  }

  // Unauthorized failure (401)
  factory Failure.unauthorized([String? message]) {
    return Failure(
      message: message ?? 'غير مصرح بالدخول',
      type: FailureType.unauthorized,
      statusCode: 401,
    );
  }

  // Forbidden failure (403)
  factory Failure.forbidden([String? message]) {
    return Failure(
      message: message ?? 'ليس لديك صلاحية للوصول',
      type: FailureType.forbidden,
      statusCode: 403,
    );
  }

  // Not found failure (404)
  factory Failure.notFound([String? message]) {
    return Failure(
      message: message ?? 'المورد غير موجود',
      type: FailureType.notFound,
      statusCode: 404,
    );
  }

  // Server failure (500+)
  factory Failure.server(String message, [int? statusCode]) {
    return Failure(
      message: message,
      type: FailureType.server,
      statusCode: statusCode ?? 500,
    );
  }

  // Parse failure (JSON parsing error)
  factory Failure.parse([String? message]) {
    return Failure(
      message: message ?? 'خطأ في معالجة البيانات',
      type: FailureType.parse,
    );
  }

  // Unknown failure
  factory Failure.unknown([String? message]) {
    return Failure(
      message: message ?? 'حدث خطأ غير متوقع',
      type: FailureType.unknown,
    );
  }

  @override
  List<Object?> get props => [message, data, statusCode, type];

  @override
  String toString() =>
      'Failure(type: $type, message: $message, statusCode: $statusCode)';
}

enum FailureType {
  network,
  timeout,
  validation,
  unauthorized,
  forbidden,
  notFound,
  server,
  parse,
  unknown,
}
