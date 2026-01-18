import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class for beautiful and organized console logging.
class AppLogger {
  // ANSI Color codes for the console
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';

  /// Log an informative message
  static void info(String message, {String? tag}) {
    _log('$_blue[INFO]$_reset', message, tag: tag);
  }

  /// Log a success message
  static void success(String message, {String? tag}) {
    _log('$_green[SUCCESS]$_reset', message, tag: tag);
  }

  /// Log a warning message
  static void warning(String message, {String? tag}) {
    _log('$_yellow[WARNING]$_reset', message, tag: tag);
  }

  /// Log an error message
  static void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    _log('$_red[ERROR]$_reset', message, tag: tag);
    if (error != null) {
      _log('$_red[DETAILS]$_reset', error.toString(), tag: tag);
    }
    if (stackTrace != null) {
      _log('$_red[STACKTRACE]$_reset', stackTrace.toString(), tag: tag);
    }
  }

  /// Log a debug message (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _log('$_magenta[DEBUG]$_reset', message, tag: tag);
    }
  }

  /// Internal log method with formatting
  static void _log(String level, String message, {String? tag}) {
    final timestamp = DateTime.now()
        .toString()
        .split(' ')
        .last
        .substring(0, 12);
    final tagSection = tag != null ? ' $_cyan[$tag]$_reset' : '';

    // Using developer.log for better integration with DevTools
    developer.log(message, name: tag ?? 'APP', time: DateTime.now());

    // Also printing to console with colors (some IDEs support ANSI colors)
    if (kDebugMode) {
      print('$timestamp $level$tagSection: $message');
    }
  }
}
