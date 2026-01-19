class StudentWalletConfigRequest {
  final int studentId;
  final double? dailyLimit;
  final double? weeklyLimit;
  final double? monthlyLimit;
  final bool allowNegativeBalance;
  final double? minimumBalance;
  final bool notifyOnLowBalance;
  final double? lowBalanceThreshold;

  StudentWalletConfigRequest({
    required this.studentId,
    this.dailyLimit,
    this.weeklyLimit,
    this.monthlyLimit,
    this.allowNegativeBalance = false,
    this.minimumBalance,
    this.notifyOnLowBalance = true,
    this.lowBalanceThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      if (dailyLimit != null) 'dailyLimit': dailyLimit,
      if (weeklyLimit != null) 'weeklyLimit': weeklyLimit,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      'allowNegativeBalance': allowNegativeBalance,
      if (minimumBalance != null) 'minimumBalance': minimumBalance,
      'notifyOnLowBalance': notifyOnLowBalance,
      if (lowBalanceThreshold != null)
        'lowBalanceThreshold': lowBalanceThreshold,
    };
  }

  factory StudentWalletConfigRequest.fromJson(Map<String, dynamic> json) {
    return StudentWalletConfigRequest(
      studentId: json['studentId'] as int,
      dailyLimit: json['dailyLimit'] != null
          ? (json['dailyLimit'] as num).toDouble()
          : null,
      weeklyLimit: json['weeklyLimit'] != null
          ? (json['weeklyLimit'] as num).toDouble()
          : null,
      monthlyLimit: json['monthlyLimit'] != null
          ? (json['monthlyLimit'] as num).toDouble()
          : null,
      allowNegativeBalance: json['allowNegativeBalance'] as bool? ?? false,
      minimumBalance: json['minimumBalance'] != null
          ? (json['minimumBalance'] as num).toDouble()
          : null,
      notifyOnLowBalance: json['notifyOnLowBalance'] as bool? ?? true,
      lowBalanceThreshold: json['lowBalanceThreshold'] != null
          ? (json['lowBalanceThreshold'] as num).toDouble()
          : null,
    );
  }

  StudentWalletConfigRequest copyWith({
    int? studentId,
    double? dailyLimit,
    double? weeklyLimit,
    double? monthlyLimit,
    bool? allowNegativeBalance,
    double? minimumBalance,
    bool? notifyOnLowBalance,
    double? lowBalanceThreshold,
  }) {
    return StudentWalletConfigRequest(
      studentId: studentId ?? this.studentId,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      allowNegativeBalance: allowNegativeBalance ?? this.allowNegativeBalance,
      minimumBalance: minimumBalance ?? this.minimumBalance,
      notifyOnLowBalance: notifyOnLowBalance ?? this.notifyOnLowBalance,
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
    );
  }
}
