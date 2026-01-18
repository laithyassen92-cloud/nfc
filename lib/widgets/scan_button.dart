import 'package:flutter/material.dart';

/// Animated scan button widget
class ScanButton extends StatelessWidget {
  final bool isAvailable;
  final bool isScanning;
  final VoidCallback onPressed;
  final VoidCallback onCancel;

  const ScanButton({
    super.key,
    required this.isAvailable,
    required this.isScanning,
    required this.onPressed,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isScanning) {
      // Show cancel button while scanning
      return OutlinedButton.icon(
        onPressed: onCancel,
        icon: const Icon(Icons.close),
        label: const Text('Cancel Scan'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          side: BorderSide(color: colorScheme.error),
          foregroundColor: colorScheme.error,
        ),
      );
    }

    return FilledButton.icon(
      onPressed: isAvailable ? onPressed : null,
      icon: const Icon(Icons.nfc, size: 24),
      label: const Text(
        'Scan NFC Tag',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
