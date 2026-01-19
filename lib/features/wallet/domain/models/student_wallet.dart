import 'wallet_status.dart';

class StudentWallet {
  final int id;
  final int studentId;
  final String studentName;
  final double balance;
  final WalletStatus status;
  final double? dailyLimit;
  final double? weeklyLimit;
  final double? monthlyLimit;
  final double dailySpent;
  final double weeklySpent;
  final double monthlySpent;
  final bool allowNegativeBalance;
  final double? minimumBalance;
  final bool notifyOnLowBalance;
  final double? lowBalanceThreshold;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastTransactionDate;

  StudentWallet({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.balance,
    required this.status,
    this.dailyLimit,
    this.weeklyLimit,
    this.monthlyLimit,
    this.dailySpent = 0,
    this.weeklySpent = 0,
    this.monthlySpent = 0,
    this.allowNegativeBalance = false,
    this.minimumBalance,
    this.notifyOnLowBalance = true,
    this.lowBalanceThreshold,
    required this.createdAt,
    this.updatedAt,
    this.lastTransactionDate,
  });

  factory StudentWallet.fromJson(Map<String, dynamic> json) {
    return StudentWallet(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      studentName: json['studentName'] as String,
      balance: (json['balance'] as num).toDouble(),
      status: WalletStatus.fromJson(json['status'] as String),
      dailyLimit: json['dailyLimit'] != null
          ? (json['dailyLimit'] as num).toDouble()
          : null,
      weeklyLimit: json['weeklyLimit'] != null
          ? (json['weeklyLimit'] as num).toDouble()
          : null,
      monthlyLimit: json['monthlyLimit'] != null
          ? (json['monthlyLimit'] as num).toDouble()
          : null,
      dailySpent: json['dailySpent'] != null
          ? (json['dailySpent'] as num).toDouble()
          : 0,
      weeklySpent: json['weeklySpent'] != null
          ? (json['weeklySpent'] as num).toDouble()
          : 0,
      monthlySpent: json['monthlySpent'] != null
          ? (json['monthlySpent'] as num).toDouble()
          : 0,
      allowNegativeBalance: json['allowNegativeBalance'] as bool? ?? false,
      minimumBalance: json['minimumBalance'] != null
          ? (json['minimumBalance'] as num).toDouble()
          : null,
      notifyOnLowBalance: json['notifyOnLowBalance'] as bool? ?? true,
      lowBalanceThreshold: json['lowBalanceThreshold'] != null
          ? (json['lowBalanceThreshold'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastTransactionDate: json['lastTransactionDate'] != null
          ? DateTime.parse(json['lastTransactionDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'balance': balance,
      'status': status.toJson(),
      if (dailyLimit != null) 'dailyLimit': dailyLimit,
      if (weeklyLimit != null) 'weeklyLimit': weeklyLimit,
      if (monthlyLimit != null) 'monthlyLimit': monthlyLimit,
      'dailySpent': dailySpent,
      'weeklySpent': weeklySpent,
      'monthlySpent': monthlySpent,
      'allowNegativeBalance': allowNegativeBalance,
      if (minimumBalance != null) 'minimumBalance': minimumBalance,
      'notifyOnLowBalance': notifyOnLowBalance,
      if (lowBalanceThreshold != null)
        'lowBalanceThreshold': lowBalanceThreshold,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (lastTransactionDate != null)
        'lastTransactionDate': lastTransactionDate!.toIso8601String(),
    };
  }

  bool get isLowBalance {
    if (lowBalanceThreshold != null) {
      return balance <= lowBalanceThreshold!;
    }
    return false;
  }

  bool canWithdraw(double amount) {
    if (!status.isUsable) return false;

    final newBalance = balance - amount;
    if (!allowNegativeBalance && newBalance < 0) return false;
    if (minimumBalance != null && newBalance < minimumBalance!) return false;

    if (dailyLimit != null && dailySpent + amount > dailyLimit!) return false;
    if (weeklyLimit != null && weeklySpent + amount > weeklyLimit!)
      return false;
    if (monthlyLimit != null && monthlySpent + amount > monthlyLimit!)
      return false;

    return true;
  }

  double? get dailyRemaining =>
      dailyLimit != null ? dailyLimit! - dailySpent : null;
  double? get weeklyRemaining =>
      weeklyLimit != null ? weeklyLimit! - weeklySpent : null;
  double? get monthlyRemaining =>
      monthlyLimit != null ? monthlyLimit! - monthlySpent : null;

  StudentWallet copyWith({
    int? id,
    int? studentId,
    String? studentName,
    double? balance,
    WalletStatus? status,
    double? dailyLimit,
    double? weeklyLimit,
    double? monthlyLimit,
    double? dailySpent,
    double? weeklySpent,
    double? monthlySpent,
    bool? allowNegativeBalance,
    double? minimumBalance,
    bool? notifyOnLowBalance,
    double? lowBalanceThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastTransactionDate,
  }) {
    return StudentWallet(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      weeklyLimit: weeklyLimit ?? this.weeklyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      dailySpent: dailySpent ?? this.dailySpent,
      weeklySpent: weeklySpent ?? this.weeklySpent,
      monthlySpent: monthlySpent ?? this.monthlySpent,
      allowNegativeBalance: allowNegativeBalance ?? this.allowNegativeBalance,
      minimumBalance: minimumBalance ?? this.minimumBalance,
      notifyOnLowBalance: notifyOnLowBalance ?? this.notifyOnLowBalance,
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
    );
  }
}
