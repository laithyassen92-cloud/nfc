class WithdrawTransactionRequest {
  final int studentId;
  final double amount;
  final String? notes;
  final String? purpose; // Lunch, Books, etc.
  final DateTime? transactionDate;

  WithdrawTransactionRequest({
    required this.studentId,
    required this.amount,
    this.notes,
    this.purpose,
    this.transactionDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'amount': amount,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (purpose != null && purpose!.isNotEmpty) 'purpose': purpose,
      if (transactionDate != null)
        'transactionDate': transactionDate!.toIso8601String(),
    };
  }

  factory WithdrawTransactionRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawTransactionRequest(
      studentId: json['studentId'] as int,
      amount: (json['amount'] as num).toDouble(),
      notes: json['notes'] as String?,
      purpose: json['purpose'] as String?,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'] as String)
          : null,
    );
  }

  WithdrawTransactionRequest copyWith({
    int? studentId,
    double? amount,
    String? notes,
    String? purpose,
    DateTime? transactionDate,
  }) {
    return WithdrawTransactionRequest(
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      purpose: purpose ?? this.purpose,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }
}
