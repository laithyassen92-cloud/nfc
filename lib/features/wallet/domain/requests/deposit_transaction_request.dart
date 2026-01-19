class DepositTransactionRequest {
  final int studentId;
  final double amount;
  final String paymentMethod; // Cash, Card, Transfer
  final String? referenceNumber;
  final String? notes;
  final DateTime? transactionDate;

  DepositTransactionRequest({
    required this.studentId,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
    this.transactionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      if (referenceNumber != null && referenceNumber!.isNotEmpty)
        'referenceNumber': referenceNumber,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (transactionDate != null)
        'transactionDate': transactionDate!.toIso8601String(),
    };
  }

  factory DepositTransactionRequest.fromJson(Map<String, dynamic> json) {
    return DepositTransactionRequest(
      studentId: json['studentId'] as int,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      referenceNumber: json['referenceNumber'] as String?,
      notes: json['notes'] as String?,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'] as String)
          : null,
    );
  }

  DepositTransactionRequest copyWith({
    int? studentId,
    double? amount,
    String? paymentMethod,
    String? referenceNumber,
    String? notes,
    DateTime? transactionDate,
  }) {
    return DepositTransactionRequest(
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      notes: notes ?? this.notes,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }
}
