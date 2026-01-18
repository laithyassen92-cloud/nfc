import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

/// Card widget displaying NFC availability status
class AvailabilityCard extends StatelessWidget {
  final NFCAvailability availability;

  const AvailabilityCard({
    super.key,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: _getBackgroundColor(colorScheme),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Status icon with animated container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(colorScheme),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                color: _getIconColor(colorScheme),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NFC Status',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusText(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getTextColor(colorScheme),
                    ),
                  ),
                ],
              ),
            ),
            // Status indicator dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getIndicatorColor(),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getIndicatorColor().withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (availability) {
      case NFCAvailability.available:
        return Icons.nfc;
      case NFCAvailability.disabled:
        return Icons.nfc;
      case NFCAvailability.not_supported:
        return Icons.signal_wifi_off;
    }
  }

  String _getStatusText() {
    switch (availability) {
      case NFCAvailability.available:
        return 'NFC is available and ready to scan';
      case NFCAvailability.disabled:
        return 'NFC is disabled. Please enable it in device settings.';
      case NFCAvailability.not_supported:
        return 'NFC is not supported on this device';
    }
  }

  Color _getIndicatorColor() {
    switch (availability) {
      case NFCAvailability.available:
        return Colors.green;
      case NFCAvailability.disabled:
        return Colors.orange;
      case NFCAvailability.not_supported:
        return Colors.red;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (availability) {
      case NFCAvailability.available:
        return colorScheme.primaryContainer.withOpacity(0.3);
      case NFCAvailability.disabled:
        return Colors.orange.withOpacity(0.1);
      case NFCAvailability.not_supported:
        return colorScheme.errorContainer.withOpacity(0.3);
    }
  }

  Color _getIconBackgroundColor(ColorScheme colorScheme) {
    switch (availability) {
      case NFCAvailability.available:
        return colorScheme.primary.withOpacity(0.1);
      case NFCAvailability.disabled:
        return Colors.orange.withOpacity(0.1);
      case NFCAvailability.not_supported:
        return colorScheme.error.withOpacity(0.1);
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    switch (availability) {
      case NFCAvailability.available:
        return colorScheme.primary;
      case NFCAvailability.disabled:
        return Colors.orange;
      case NFCAvailability.not_supported:
        return colorScheme.error;
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    switch (availability) {
      case NFCAvailability.available:
        return colorScheme.primary;
      case NFCAvailability.disabled:
        return Colors.orange.shade700;
      case NFCAvailability.not_supported:
        return colorScheme.error;
    }
  }
}
