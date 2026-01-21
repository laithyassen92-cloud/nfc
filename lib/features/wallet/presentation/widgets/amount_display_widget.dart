// lib/features/wallet/presentation/widgets/amount_display_widget.dart

import 'package:flutter/material.dart';

/// ويدجت لعرض المبلغ بشكل أنيق
class AmountDisplayWidget extends StatelessWidget {
  final String amount;
  final String currency;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final bool showCursor;

  const AmountDisplayWidget({
    super.key,
    required this.amount,
    this.currency = 'ر.س',
    this.label = 'المبلغ',
    this.backgroundColor,
    this.textColor,
    this.fontSize = 48,
    this.showCursor = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor =
        backgroundColor ?? theme.colorScheme.surfaceVariant;
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;

    final displayAmount = amount.isEmpty ? '0' : amount;
    final formattedAmount = _formatAmount(displayAmount);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: effectiveTextColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // المبلغ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // المبلغ مع المؤشر
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: formattedAmount,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: effectiveTextColor,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (showCursor)
                      TextSpan(
                        text: '|',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w300,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // العملة
              Text(
                currency,
                style: TextStyle(
                  fontSize: fontSize * 0.4,
                  fontWeight: FontWeight.w500,
                  color: effectiveTextColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    // تنسيق الأرقام مع الفواصل
    if (amount.isEmpty) return '0';

    try {
      final parts = amount.split('.');
      final integerPart = parts[0];
      final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      // إضافة فواصل الآلاف
      final formatted = integerPart.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );

      return '$formatted$decimalPart';
    } catch (e) {
      return amount;
    }
  }
}

/// ويدجت لعرض معلومات البطاقة
class CardInfoWidget extends StatelessWidget {
  final String? uid;
  final double? balance;
  final String? holderName;
  final bool isScanning;
  final String? error;

  const CardInfoWidget({
    super.key,
    this.uid,
    this.balance,
    this.holderName,
    this.isScanning = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (error != null) {
      return _buildErrorCard(theme);
    }

    if (isScanning) {
      return _buildScanningCard(theme);
    }

    if (uid == null) {
      return _buildWaitingCard(theme);
    }

    return _buildCardInfo(theme);
  }

  Widget _buildErrorCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(error!, style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'جارٍ قراءة البطاقة...',
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.nfc, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            'قرّب البطاقة من الجهاز',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_card, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'بطاقة متصلة',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          if (holderName != null) ...[
            Text(
              holderName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            'UID: ${_formatUid(uid!)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
          if (balance != null) ...[
            const Divider(color: Colors.white24, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الرصيد الحالي:',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${balance!.toStringAsFixed(2)} ر.س',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatUid(String uid) {
    // تنسيق UID بإضافة فواصل
    final buffer = StringBuffer();
    for (var i = 0; i < uid.length; i++) {
      buffer.write(uid[i]);
      if ((i + 1) % 2 == 0 && i < uid.length - 1) {
        buffer.write(':');
      }
    }
    return buffer.toString().toUpperCase();
  }
}
