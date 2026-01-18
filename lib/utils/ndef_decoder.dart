import 'dart:convert';
import 'dart:typed_data';
import 'package:ndef/ndef.dart';

/// Utility class for decoding NDEF payloads into human-readable format
class NdefDecoder {
  /// Decode NDEF record payload to human-readable format
  static String decodePayload(NDEFRecord record) {
    if (record.payload == null || record.payload!.isEmpty) {
      return '[Empty payload]';
    }

    try {
      // Handle based on Type Name Format (TNF)
      switch (record.tnf) {
        case TypeNameFormat.nfcWellKnown:
          return _decodeWellKnownType(record);
        case TypeNameFormat.media:
          return _decodeMediaType(record);
        case TypeNameFormat.absoluteURI:
          return _decodeAbsoluteUri(record);
        case TypeNameFormat.nfcExternal:
          return _decodeExternalType(record);
        case TypeNameFormat.empty:
          return '[Empty record]';
        case TypeNameFormat.unknown:
        case TypeNameFormat.unchanged:
        default:
          return _decodeRawPayload(record.payload!);
      }
    } catch (e) {
      return 'Error decoding payload: $e';
    }
  }

  /// Decode NFC Well Known types (T = Text, U = URI, etc.)
  static String _decodeWellKnownType(NDEFRecord record) {
    final typeBytes = record.type;
    if (typeBytes == null || typeBytes.isEmpty) {
      return 'Well-Known (No Type)\n${_decodeRawPayload(record.payload!)}';
    }

    final type = utf8.decode(typeBytes, allowMalformed: true);

    switch (type) {
      case 'T':
        return _decodeTextRecord(record.payload!);
      case 'U':
        return _decodeUriRecord(record.payload!);
      case 'Sp':
        return _decodeSmartPoster(record);
      default:
        return 'Well-Known Type: $type\n${_decodeRawPayload(record.payload!)}';
    }
  }

  /// Decode Text record (RTD_TEXT)
  static String _decodeTextRecord(Uint8List bytes) {
    try {
      if (bytes.isEmpty) return '[Empty text]';

      // First byte: status byte
      // Bit 7: encoding (0 = UTF-8, 1 = UTF-16)
      // Bits 5-0: language code length
      final statusByte = bytes[0];
      final isUtf16 = (statusByte & 0x80) != 0;
      final languageCodeLength = statusByte & 0x3F;

      if (bytes.length <= 1 + languageCodeLength) {
        return '[Invalid text record structure]';
      }

      // Extract language code
      final languageCode = utf8.decode(
        bytes.sublist(1, 1 + languageCodeLength),
      );

      // Extract text content
      final textBytes = bytes.sublist(1 + languageCodeLength);

      String text;
      if (isUtf16) {
        // Handle UTF-16 encoding
        final byteData = ByteData.sublistView(Uint8List.fromList(textBytes));
        final buffer = StringBuffer();
        for (int i = 0; i < textBytes.length - 1; i += 2) {
          buffer.writeCharCode(byteData.getUint16(i, Endian.big));
        }
        text = buffer.toString();
      } else {
        // UTF-8 encoding
        text = utf8.decode(textBytes, allowMalformed: true);
      }

      return '📝 Text Record\n'
          'Language: $languageCode\n'
          'Content: $text';
    } catch (e) {
      return 'Error decoding text: $e';
    }
  }

  /// Decode URI record (RTD_URI)
  static String _decodeUriRecord(Uint8List bytes) {
    try {
      if (bytes.isEmpty) return '[Empty URI]';

      // First byte: URI identifier code
      final uriCode = bytes[0];
      final uriPrefix = _getUriPrefix(uriCode);

      // Rest is the URI suffix
      final uriSuffix = utf8.decode(bytes.sublist(1), allowMalformed: true);

      final fullUri = '$uriPrefix$uriSuffix';

      return '🔗 URI Record\n$fullUri';
    } catch (e) {
      return 'Error decoding URI: $e';
    }
  }

  /// Decode Smart Poster record
  static String _decodeSmartPoster(NDEFRecord record) {
    return '📱 Smart Poster\n${_decodeRawPayload(record.payload!)}';
  }

  /// Decode Media type (MIME type)
  static String _decodeMediaType(NDEFRecord record) {
    try {
      final typeBytes = record.type;
      final mimeType = typeBytes != null
          ? utf8.decode(typeBytes, allowMalformed: true)
          : 'unknown';
      final bytes = record.payload!;

      // Try to decode as text if it's a text-based MIME type
      if (mimeType.startsWith('text/') ||
          mimeType.contains('json') ||
          mimeType.contains('xml')) {
        final text = utf8.decode(bytes, allowMalformed: true);
        return '📄 Media: $mimeType\n$text';
      }

      // For binary types, show hex representation
      return '📄 Media: $mimeType\n${_bytesToHex(bytes)}';
    } catch (e) {
      return 'Error decoding media: $e';
    }
  }

  /// Decode Absolute URI type
  static String _decodeAbsoluteUri(NDEFRecord record) {
    try {
      final typeBytes = record.type;
      final uri = typeBytes != null
          ? utf8.decode(typeBytes, allowMalformed: true)
          : 'unknown';
      return '🌐 Absolute URI\n$uri';
    } catch (e) {
      return 'Error decoding absolute URI: $e';
    }
  }

  /// Decode External type (Android Application Record, etc.)
  static String _decodeExternalType(NDEFRecord record) {
    try {
      final typeBytes = record.type;
      final type = typeBytes != null
          ? utf8.decode(typeBytes, allowMalformed: true)
          : 'unknown';
      final bytes = record.payload!;

      // Check for Android Application Record
      if (type == 'android.com:pkg') {
        final packageName = utf8.decode(bytes, allowMalformed: true);
        return '🤖 Android App Record\nPackage: $packageName';
      }

      // Generic external type
      final content = _tryDecodeAsText(bytes);
      return '📦 External: $type\n$content';
    } catch (e) {
      return 'Error decoding external type: $e';
    }
  }

  /// Try to decode bytes as text, fall back to hex
  static String _tryDecodeAsText(Uint8List bytes) {
    if (_isPrintableText(bytes)) {
      return utf8.decode(bytes, allowMalformed: true);
    }
    return _bytesToHex(bytes);
  }

  /// Decode raw payload (fallback)
  static String _decodeRawPayload(Uint8List bytes) {
    try {
      // Try to decode as UTF-8 text first
      if (_isPrintableText(bytes)) {
        return utf8.decode(bytes, allowMalformed: true);
      }

      // Fall back to hex representation
      return _bytesToHex(bytes);
    } catch (_) {
      return _bytesToHex(bytes);
    }
  }

  /// Check if bytes represent printable text
  static bool _isPrintableText(Uint8List bytes) {
    for (final byte in bytes) {
      // Allow printable ASCII, newlines, tabs
      if (byte < 0x20 || byte > 0x7E) {
        if (byte != 0x0A && byte != 0x0D && byte != 0x09) {
          // Also allow UTF-8 continuation bytes
          if (byte < 0x80 || byte > 0xBF) {
            if (byte < 0xC0 || byte > 0xF7) {
              return false;
            }
          }
        }
      }
    }
    return bytes.isNotEmpty;
  }

  /// Convert bytes to formatted hex string
  static String _bytesToHex(Uint8List bytes) {
    if (bytes.isEmpty) return '[Empty]';

    final buffer = StringBuffer();
    for (int i = 0; i < bytes.length; i++) {
      if (i > 0 && i % 16 == 0) {
        buffer.write('\n');
      } else if (i > 0) {
        buffer.write(' ');
      }
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0').toUpperCase());
    }
    return buffer.toString();
  }

  /// Get URI prefix from identifier code (NFC Forum URI RTD)
  static String _getUriPrefix(int code) {
    const prefixes = <int, String>{
      0x00: '',
      0x01: 'http://www.',
      0x02: 'https://www.',
      0x03: 'http://',
      0x04: 'https://',
      0x05: 'tel:',
      0x06: 'mailto:',
      0x07: 'ftp://anonymous:anonymous@',
      0x08: 'ftp://ftp.',
      0x09: 'ftps://',
      0x0A: 'sftp://',
      0x0B: 'smb://',
      0x0C: 'nfs://',
      0x0D: 'ftp://',
      0x0E: 'dav://',
      0x0F: 'news:',
      0x10: 'telnet://',
      0x11: 'imap:',
      0x12: 'rtsp://',
      0x13: 'urn:',
      0x14: 'pop:',
      0x15: 'sip:',
      0x16: 'sips:',
      0x17: 'tftp:',
      0x18: 'btspp://',
      0x19: 'btl2cap://',
      0x1A: 'btgoep://',
      0x1B: 'tcpobex://',
      0x1C: 'irdaobex://',
      0x1D: 'file://',
      0x1E: 'urn:epc:id:',
      0x1F: 'urn:epc:tag:',
      0x20: 'urn:epc:pat:',
      0x21: 'urn:epc:raw:',
      0x22: 'urn:epc:',
      0x23: 'urn:nfc:',
    };

    return prefixes[code] ?? '';
  }

  /// Get human-readable TNF name
  static String getTnfName(TypeNameFormat tnf) {
    switch (tnf) {
      case TypeNameFormat.empty:
        return 'Empty';
      case TypeNameFormat.nfcWellKnown:
        return 'NFC Well Known';
      case TypeNameFormat.media:
        return 'Media (MIME)';
      case TypeNameFormat.absoluteURI:
        return 'Absolute URI';
      case TypeNameFormat.nfcExternal:
        return 'NFC External';
      case TypeNameFormat.unknown:
        return 'Unknown';
      case TypeNameFormat.unchanged:
        return 'Unchanged';
    }
  }
}
