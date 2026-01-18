// lib/models/cash_transaction.dart

import 'package:flutter/foundation.dart';

enum TransactionType { cashIn, cashOut }

enum TransactionStatus { pending, success, failed, cancelled }

@immutable
class CashTransaction {
  final String id;
  final String cardUid;
  final TransactionType type;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? errorMessage;

  const CashTransaction({
    required this.id,
    required this.cardUid,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.status,
    required this.timestamp,
    this.errorMessage,
  });

  /// إنشاء معاملة جديدة
  factory CashTransaction.create({
    required String cardUid,
    required TransactionType type,
    required double amount,
    required double currentBalance,
  }) {
    final balanceAfter = type == TransactionType.cashIn
        ? currentBalance + amount
        : currentBalance - amount;

    return CashTransaction(
      id: _generateId(),
      cardUid: cardUid,
      type: type,
      amount: amount,
      balanceBefore: currentBalance,
      balanceAfter: balanceAfter,
      status: TransactionStatus.pending,
      timestamp: DateTime.now(),
    );
  }

  /// نسخة مع تحديث الحالة
  CashTransaction copyWith({TransactionStatus? status, String? errorMessage}) {
    return CashTransaction(
      id: id,
      cardUid: cardUid,
      type: type,
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      status: status ?? this.status,
      timestamp: timestamp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// توليد معرف فريد
  static String _generateId() {
    return 'TXN_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// تحويل إلى Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardUid': cardUid,
      'type': type.name,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'errorMessage': errorMessage,
    };
  }

  /// إنشاء من Map
  factory CashTransaction.fromMap(Map<String, dynamic> map) {
    return CashTransaction(
      id: map['id'] as String,
      cardUid: map['cardUid'] as String,
      type: TransactionType.values.byName(map['type'] as String),
      amount: (map['amount'] as num).toDouble(),
      balanceBefore: (map['balanceBefore'] as num).toDouble(),
      balanceAfter: (map['balanceAfter'] as num).toDouble(),
      status: TransactionStatus.values.byName(map['status'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
      errorMessage: map['errorMessage'] as String?,
    );
  }

  @override
  String toString() {
    return 'CashTransaction(id: $id, type: $type, amount: $amount, status: $status)';
  }
}

/// نموذج بيانات البطاقة
@immutable
class CardData {
  final String uid;
  final double balance;
  final String? holderName;
  final DateTime? expiryDate;
  final bool isActive;

  const CardData({
    required this.uid,
    required this.balance,
    this.holderName,
    this.expiryDate,
    this.isActive = true,
  });

  CardData copyWith({double? balance}) {
    return CardData(
      uid: uid,
      balance: balance ?? this.balance,
      holderName: holderName,
      expiryDate: expiryDate,
      isActive: isActive,
    );
  }

  bool get isValid {
    if (!isActive) return false;
    if (expiryDate != null && expiryDate!.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'balance': balance,
      'holderName': holderName,
      'expiryDate': expiryDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory CardData.fromMap(Map<String, dynamic> map) {
    return CardData(
      uid: map['uid'] as String,
      balance: (map['balance'] as num).toDouble(),
      holderName: map['holderName'] as String?,
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'] as String)
          : null,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
