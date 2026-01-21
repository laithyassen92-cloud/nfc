class RefundTransactionRequest {
  final String studentNumber;
  final String orginalTransactionRefNumber;

  RefundTransactionRequest({
    required this.studentNumber,
    required this.orginalTransactionRefNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentNumber': studentNumber,
      'orginalTransactionRefNumber': orginalTransactionRefNumber,
    };
  }

  factory RefundTransactionRequest.fromJson(Map<String, dynamic> json) {
    return RefundTransactionRequest(
      studentNumber: json['studentNumber'] as String,
      orginalTransactionRefNumber:
          json['orginalTransactionRefNumber'] as String,
    );
  }

  RefundTransactionRequest copyWith({
    String? studentNumber,
    String? orginalTransactionRefNumber,
  }) {
    return RefundTransactionRequest(
      studentNumber: studentNumber ?? this.studentNumber,
      orginalTransactionRefNumber:
          orginalTransactionRefNumber ?? this.orginalTransactionRefNumber,
    );
  }
}
