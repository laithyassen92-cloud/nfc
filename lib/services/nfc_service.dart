import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart';
import '../core/logger.dart';
import '../models/nfc_result.dart';

/// Custom exception for NFC operations
class NfcException implements Exception {
  final String message;

  NfcException(this.message);

  @override
  String toString() => message;
}

/// Service class for handling NFC operations
/// Separates NFC logic from UI components
class NfcService {
  /// Check NFC availability on the device
  Future<NFCAvailability> checkAvailability() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    AppLogger.info(
      'NFC Availability Checked: $availability',
      tag: 'NfcService',
    );
    return availability;
  }

  /// Scan for NFC tags and read NDEF records
  /// Returns [NfcScanResult] containing tag info and NDEF records
  /// Throws [NfcException] on errors
  Future<NfcScanResult> scanTag({
    Duration timeout = const Duration(seconds: 20),
    String iosAlertMessage = 'Hold your device near an NFC tag',
    String iosSuccessMessage = 'Tag read successfully!',
  }) async {
    AppLogger.info('Starting NFC Scan...', tag: 'NfcService');
    NFCTag? tag;
    List<NDEFRecord>? ndefRecords;

    try {
      // Start polling for NFC tags
      tag = await FlutterNfcKit.poll(
        timeout: timeout,
        iosMultipleTagMessage:
            'Multiple tags detected. Please present only one tag.',
        iosAlertMessage: iosAlertMessage,
      );

      AppLogger.success(
        'Tag detected: ${tag.id} (${tag.type})',
        tag: 'NfcService',
      );

      // Read NDEF records if available
      if (tag.ndefAvailable == true) {
        try {
          AppLogger.info('Reading NDEF records...', tag: 'NfcService');
          ndefRecords = await FlutterNfcKit.readNDEFRecords();
          AppLogger.success(
            'Read ${ndefRecords.length} NDEF records',
            tag: 'NfcService',
          );
        } catch (e) {
          AppLogger.warning(
            'Failed to read NDEF records: $e',
            tag: 'NfcService',
          );
          // Log but don't fail - tag info is still valuable
          ndefRecords = null;
        }
      }

      // Finish the session successfully
      await FlutterNfcKit.finish(iosAlertMessage: iosSuccessMessage);

      return NfcScanResult(tag: tag, ndefRecords: ndefRecords ?? []);
    } catch (e) {
      // Handle errors
      String errorMessage = 'An NFC error occurred';

      if (e is Exception) {
        errorMessage = e.toString();
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
      }

      AppLogger.error(
        'NFC Scan failed: $errorMessage',
        error: e,
        tag: 'NfcService',
      );

      // Finish session with error message
      await FlutterNfcKit.finish(iosErrorMessage: errorMessage);

      throw NfcException(errorMessage);
    }
  }

  /// Cancel ongoing NFC scan
  Future<void> cancelScan() async {
    try {
      await FlutterNfcKit.finish(iosErrorMessage: 'Scan cancelled');
    } catch (_) {
      // Ignore errors when cancelling
    }
  }

  /// Clean up resources
  void dispose() {
    // Ensure any pending session is closed
    FlutterNfcKit.finish().catchError((_) {});
  }
}
