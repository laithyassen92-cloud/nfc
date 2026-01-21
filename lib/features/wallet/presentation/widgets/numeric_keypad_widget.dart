// lib/features/wallet/presentation/widgets/numeric_keypad_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Callback عند تغيير القيمة
typedef OnAmountChanged = void Function(String amount);

/// لوحة أرقام مخصصة لتجنب مشاكل لوحة المفاتيح مع NFC
class NumericKeypadWidget extends StatelessWidget {
  final OnAmountChanged onAmountChanged;
  final String currentAmount;
  final int maxDigits;
  final int decimalPlaces;
  final bool enabled;
  final Color? buttonColor;
  final Color? textColor;
  final double buttonSize;
  final double spacing;

  const NumericKeypadWidget({
    super.key,
    required this.onAmountChanged,
    required this.currentAmount,
    this.maxDigits = 8,
    this.decimalPlaces = 2,
    this.enabled = true,
    this.buttonColor,
    this.textColor,
    this.buttonSize = 70,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveButtonColor = buttonColor ?? theme.colorScheme.surface;
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الصفوف 1-2-3
            _buildRow(
              ['1', '2', '3'],
              effectiveButtonColor,
              effectiveTextColor,
            ),
            SizedBox(height: spacing),
            // الصفوف 4-5-6
            _buildRow(
              ['4', '5', '6'],
              effectiveButtonColor,
              effectiveTextColor,
            ),
            SizedBox(height: spacing),
            // الصفوف 7-8-9
            _buildRow(
              ['7', '8', '9'],
              effectiveButtonColor,
              effectiveTextColor,
            ),
            SizedBox(height: spacing),
            // الصف الأخير: مسح - 0 - حذف
            _buildRow(
              ['.', '0', '⌫'],
              effectiveButtonColor,
              effectiveTextColor,
            ),
            SizedBox(height: spacing),
            // زر المسح الكامل
            _buildClearButton(effectiveButtonColor, effectiveTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys, Color bgColor, Color txtColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: _buildKeyButton(key, bgColor, txtColor),
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton(String key, Color bgColor, Color txtColor) {
    final isBackspace = key == '⌫';
    final isDecimal = key == '.';

    return Material(
      color: isBackspace ? Colors.orange.shade100 : bgColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleKeyPress(key),
        onLongPress: isBackspace ? _handleClear : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: Colors.orange.shade800,
                  size: 28,
                )
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDecimal ? Colors.blue : txtColor,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildClearButton(Color bgColor, Color txtColor) {
    return Material(
      color: Colors.red.shade50,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _handleClear,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: buttonSize * 3 + spacing * 2,
          height: buttonSize * 0.7,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.clear_all, color: Colors.red.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                'مسح الكل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleKeyPress(String key) {
    // اهتزاز خفيف للتغذية الراجعة
    HapticFeedback.lightImpact();

    String newAmount = currentAmount;

    if (key == '⌫') {
      // حذف آخر حرف
      if (newAmount.isNotEmpty) {
        newAmount = newAmount.substring(0, newAmount.length - 1);
      }
    } else if (key == '.') {
      // إضافة فاصلة عشرية
      if (!newAmount.contains('.') &&
          newAmount.length < maxDigits - decimalPlaces) {
        if (newAmount.isEmpty) {
          newAmount = '0.';
        } else {
          newAmount += '.';
        }
      }
    } else {
      // إضافة رقم
      if (_canAddDigit(newAmount, key)) {
        // منع الأصفار في البداية (ما عدا 0.)
        if (newAmount == '0' && key != '.') {
          newAmount = key;
        } else {
          newAmount += key;
        }
      }
    }

    onAmountChanged(newAmount);
  }

  void _handleClear() {
    HapticFeedback.mediumImpact();
    onAmountChanged('');
  }

  bool _canAddDigit(String current, String digit) {
    if (current.length >= maxDigits) return false;

    // التحقق من الأرقام العشرية
    if (current.contains('.')) {
      final decimalPart = current.split('.').last;
      if (decimalPart.length >= decimalPlaces) return false;
    }

    return true;
  }
}
