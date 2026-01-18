// lib/services/transaction_service.dart

import 'dart:async';
import '../models/cash_transaction.dart';
import '../core/logger.dart';


class TransactionResult {
  final bool success;
  final CashTransaction? transaction;
  final String? errorMessage;
  final CardData? updatedCard;

  const TransactionResult({
    required this.success,
    this.transaction,
    this.errorMessage,
    this.updatedCard,
  });

  factory TransactionResult.success({
    required CashTransaction transaction,
    required CardData updatedCard,
  }) {
    return TransactionResult(
      success: true,
      transaction: transaction,
      updatedCard: updatedCard,
    );
  }

  factory TransactionResult.failure(String message) {
    return TransactionResult(success: false, errorMessage: message);
  }
}

/// خدمة إدارة المعاملات المالية
class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  // تخزين مؤقت للمعاملات (يمكن استبداله بقاعدة بيانات)
  final List<CashTransaction> _transactionHistory = [];

  // الحد الأقصى للإيداع
  static const double maxCashInAmount = 10000.0;

  // الحد الأقصى للسحب
  static const double maxCashOutAmount = 5000.0;

  // الحد الأدنى للمعاملة
  static const double minTransactionAmount = 1.0;

  /// التحقق من صحة مبلغ الإيداع
  String? validateCashInAmount(double amount, CardData card) {
    if (amount < minTransactionAmount) {
      return 'المبلغ يجب أن يكون أكبر من $minTransactionAmount';
    }
    if (amount > maxCashInAmount) {
      return 'المبلغ يتجاوز الحد الأقصى للإيداع ($maxCashInAmount)';
    }
    if (!card.isValid) {
      return 'البطاقة غير صالحة أو منتهية الصلاحية';
    }
    return null; // صالح
  }

  /// التحقق من صحة مبلغ السحب
  String? validateCashOutAmount(double amount, CardData card) {
    if (amount < minTransactionAmount) {
      return 'المبلغ يجب أن يكون أكبر من $minTransactionAmount';
    }
    if (amount > maxCashOutAmount) {
      return 'المبلغ يتجاوز الحد الأقصى للسحب ($maxCashOutAmount)';
    }
    if (amount > card.balance) {
      return 'الرصيد غير كافٍ (المتاح: ${card.balance.toStringAsFixed(2)})';
    }
    if (!card.isValid) {
      return 'البطاقة غير صالحة أو منتهية الصلاحية';
    }
    return null; // صالح
  }

  /// تنفيذ عملية الإيداع (Cash In)
  Future<TransactionResult> processCashIn({
    required CardData card,
    required double amount,
  }) async {
    AppLogger.info('بدء عملية الإيداع: $amount');

    // التحقق من الصلاحية
    final validationError = validateCashInAmount(amount, card);
    if (validationError != null) {
      AppLogger.warning('فشل التحقق: $validationError');
      return TransactionResult.failure(validationError);
    }

    try {
      // إنشاء المعاملة
      var transaction = CashTransaction.create(
        cardUid: card.uid,
        type: TransactionType.cashIn,
        amount: amount,
        currentBalance: card.balance,
      );

      // محاكاة الكتابة على البطاقة (يُستبدل بـ NFC الفعلي)
      await _simulateNfcWrite();

      // تحديث الرصيد
      final updatedCard = card.copyWith(balance: card.balance + amount);

      // تحديث حالة المعاملة
      transaction = transaction.copyWith(status: TransactionStatus.success);

      // حفظ في السجل
      _transactionHistory.add(transaction);

      AppLogger.info('تم الإيداع بنجاح: ${transaction.id}');

      return TransactionResult.success(
        transaction: transaction,
        updatedCard: updatedCard,
      );
    } catch (e) {
      AppLogger.error('فشل الإيداع: $e');
      return TransactionResult.failure('فشل في كتابة البيانات على البطاقة');
    }
  }

  /// تنفيذ عملية السحب (Cash Out)
  Future<TransactionResult> processCashOut({
    required CardData card,
    required double amount,
  }) async {
    AppLogger.info('بدء عملية السحب: $amount');

    // التحقق من الصلاحية
    final validationError = validateCashOutAmount(amount, card);
    if (validationError != null) {
      AppLogger.warning('فشل التحقق: $validationError');
      return TransactionResult.failure(validationError);
    }

    try {
      // إنشاء المعاملة
      var transaction = CashTransaction.create(
        cardUid: card.uid,
        type: TransactionType.cashOut,
        amount: amount,
        currentBalance: card.balance,
      );

      // محاكاة الكتابة على البطاقة
      await _simulateNfcWrite();

      // تحديث الرصيد
      final updatedCard = card.copyWith(balance: card.balance - amount);

      // تحديث حالة المعاملة
      transaction = transaction.copyWith(status: TransactionStatus.success);

      // حفظ في السجل
      _transactionHistory.add(transaction);

      AppLogger.info('تم السحب بنجاح: ${transaction.id}');

      return TransactionResult.success(
        transaction: transaction,
        updatedCard: updatedCard,
      );
    } catch (e) {
      AppLogger.error('فشل السحب: $e');
      return TransactionResult.failure('فشل في كتابة البيانات على البطاقة');
    }
  }

  /// محاكاة كتابة NFC (يُستبدل بالكود الفعلي)
  Future<void> _simulateNfcWrite() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// الحصول على سجل المعاملات
  List<CashTransaction> getTransactionHistory({String? cardUid}) {
    if (cardUid == null) {
      return List.unmodifiable(_transactionHistory);
    }
    return _transactionHistory.where((t) => t.cardUid == cardUid).toList();
  }

  /// الحصول على آخر معاملة
  CashTransaction? getLastTransaction({String? cardUid}) {
    final history = getTransactionHistory(cardUid: cardUid);
    return history.isNotEmpty ? history.last : null;
  }
}
