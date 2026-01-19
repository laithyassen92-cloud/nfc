class RefundTransactionRequest {
  final int transactionId; // Original transaction to refund
  final double? amount; // null means full refund
  final String reason;
  final String? notes;

  RefundTransactionRequest({
    required this.transactionId,
    this.amount,
    required this.reason,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      if (amount != null) 'amount': amount,
      'reason': reason,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  factory RefundTransactionRequest.fromJson(Map<String, dynamic> json) {
    return RefundTransactionRequest(
      transactionId: json['transactionId'] as int,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
    );
  }

  RefundTransactionRequest copyWith({
    int? transactionId,
    double? amount,
    String? reason,
    String? notes,
  }) {
    return RefundTransactionRequest(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
    );
  }
}
