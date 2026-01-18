
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart';

/// Model class representing the result of an NFC scan
class NfcScanResult {
  /// The detected NFC tag information
  final NFCTag tag;

  /// List of NDEF records found on the tag (may be empty)
  final List<NDEFRecord> ndefRecords;

  const NfcScanResult({
    required this.tag,
    required this.ndefRecords,
  });

  /// Check if the tag has any NDEF records
  bool get hasNdefRecords => ndefRecords.isNotEmpty;

  /// Check if NDEF is available on the tag
  bool get isNdefAvailable => tag.ndefAvailable ?? false;

  /// Check if the tag is writable
  bool get isWritable => tag.ndefWritable ?? false;
}
