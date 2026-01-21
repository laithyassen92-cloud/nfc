class WithdrawTransactionRequest {
  final String studentNumber;
  final double amount;

  WithdrawTransactionRequest({
    required this.studentNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {'studentNumber': studentNumber, 'amount': amount};
  }

  factory WithdrawTransactionRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawTransactionRequest(
      studentNumber: json['studentNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  WithdrawTransactionRequest copyWith({String? studentNumber, double? amount}) {
    return WithdrawTransactionRequest(
      studentNumber: studentNumber ?? this.studentNumber,
      amount: amount ?? this.amount,
    );
  }
}
