import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFBB862C);
  static const Color primaryDark = Color(0xFF946A23);
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);

  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);

  // Slate-like helper for consistent grays
  static Color slate(int weight) {
    switch (weight) {
      case 50:
        return const Color(0xFFF8FAFC);
      case 100:
        return const Color(0xFFF1F5F9);
      case 200:
        return const Color(0xFFE2E8F0);
      case 300:
        return const Color(0xFFCBD5E1);
      case 400:
        return const Color(0xFF94A3B8);
      case 500:
        return const Color(0xFF64748B);
      case 600:
        return const Color(0xFF475569);
      case 700:
        return const Color(0xFF334155);
      case 800:
        return const Color(0xFF1E293B);
      case 900:
        return const Color(0xFF0F172A);
      default:
        return const Color(0xFF64748B);
    }
  }
}
