class WalletTransaction {
  final int id;
  final int studentId;
  final String studentName;
  final String transactionType; // Deposit, Withdraw, Refund
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String? paymentMethod;
  final String? referenceNumber;
  final String? purpose;
  final String? notes;
  final DateTime transactionDate;
  final int? processedBy; // User ID who processed the transaction
  final String? processedByName;
  final int? relatedTransactionId; // For refunds
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.paymentMethod,
    this.referenceNumber,
    this.purpose,
    this.notes,
    required this.transactionDate,
    this.processedBy,
    this.processedByName,
    this.relatedTransactionId,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      studentName: json['studentName'] as String,
      transactionType: json['transactionType'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceBefore: (json['balanceBefore'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      referenceNumber: json['referenceNumber'] as String?,
      purpose: json['purpose'] as String?,
      notes: json['notes'] as String?,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      processedBy: json['processedBy'] as int?,
      processedByName: json['processedByName'] as String?,
      relatedTransactionId: json['relatedTransactionId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'transactionType': transactionType,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      if (purpose != null) 'purpose': purpose,
      if (notes != null) 'notes': notes,
      'transactionDate': transactionDate.toIso8601String(),
      if (processedBy != null) 'processedBy': processedBy,
      if (processedByName != null) 'processedByName': processedByName,
      if (relatedTransactionId != null)
        'relatedTransactionId': relatedTransactionId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isDeposit => transactionType.toLowerCase() == 'deposit';
  bool get isWithdraw => transactionType.toLowerCase() == 'withdraw';
  bool get isRefund => transactionType.toLowerCase() == 'refund';

  WalletTransaction copyWith({
    int? id,
    int? studentId,
    String? studentName,
    String? transactionType,
    double? amount,
    double? balanceBefore,
    double? balanceAfter,
    String? paymentMethod,
    String? referenceNumber,
    String? purpose,
    String? notes,
    DateTime? transactionDate,
    int? processedBy,
    String? processedByName,
    int? relatedTransactionId,
    DateTime? createdAt,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      purpose: purpose ?? this.purpose,
      notes: notes ?? this.notes,
      transactionDate: transactionDate ?? this.transactionDate,
      processedBy: processedBy ?? this.processedBy,
      processedByName: processedByName ?? this.processedByName,
      relatedTransactionId: relatedTransactionId ?? this.relatedTransactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
