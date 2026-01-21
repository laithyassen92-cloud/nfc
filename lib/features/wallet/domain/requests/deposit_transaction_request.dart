class DepositTransactionRequest {
  final String studentNumber;
  final double amount;

  DepositTransactionRequest({
    required this.studentNumber,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {'studentNumber': studentNumber, 'amount': amount};
  }

  factory DepositTransactionRequest.fromJson(Map<String, dynamic> json) {
    return DepositTransactionRequest(
      studentNumber: json['studentNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  DepositTransactionRequest copyWith({String? studentNumber, double? amount}) {
    return DepositTransactionRequest(
      studentNumber: studentNumber ?? this.studentNumber,
      amount: amount ?? this.amount,
    );
  }
}
