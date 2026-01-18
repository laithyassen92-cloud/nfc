import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

/// Card widget displaying NFC tag information
class TagInfoCard extends StatelessWidget {
  final NFCTag tagInfo;

  const TagInfoCard({
    super.key,
    required this.tagInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tag Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Copy ID button
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy Tag ID',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: tagInfo.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tag ID copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 24),
            // Tag details
            _buildInfoRow(context, 'Tag ID', tagInfo.id, isMonospace: true),
            _buildInfoRow(context, 'Type', tagInfo.type.toString().split('.').last),
            _buildInfoRow(context, 'Standard', tagInfo.standard),
            if (tagInfo.atqa != null)
              _buildInfoRow(context, 'ATQA', tagInfo.atqa!, isMonospace: true),
            if (tagInfo.sak != null)
              _buildInfoRow(context, 'SAK', tagInfo.sak!, isMonospace: true),
            if (tagInfo.historicalBytes != null)
              _buildInfoRow(context, 'Historical Bytes', tagInfo.historicalBytes!,
                  isMonospace: true),
            if (tagInfo.protocolInfo != null)
              _buildInfoRow(context, 'Protocol Info', tagInfo.protocolInfo!,
                  isMonospace: true),
            if (tagInfo.applicationData != null)
              _buildInfoRow(context, 'App Data', tagInfo.applicationData!,
                  isMonospace: true),
            const SizedBox(height: 8),
            // NDEF capabilities
            _buildCapabilityRow(
              context,
              'NDEF Available',
              tagInfo.ndefAvailable ?? false,
            ),
            _buildCapabilityRow(
              context,
              'NDEF Writable',
              tagInfo.ndefWritable ?? false,
            ),
            if (tagInfo.ndefCapacity != null)
              _buildInfoRow(
                context,
                'NDEF Capacity',
                '${tagInfo.ndefCapacity} bytes',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isMonospace = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: isMonospace ? 'monospace' : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityRow(BuildContext context, String label, bool value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: value
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  value ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: value ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  value ? 'Yes' : 'No',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: value ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
