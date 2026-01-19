enum WalletStatus {
  active,
  inactive,
  suspended,
  pending;

  String toJson() => name;

  static WalletStatus fromJson(String value) {
    return WalletStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => WalletStatus.inactive,
    );
  }

  String get displayName {
    switch (this) {
      case WalletStatus.active:
        return 'Active';
      case WalletStatus.inactive:
        return 'Inactive';
      case WalletStatus.suspended:
        return 'Suspended';
      case WalletStatus.pending:
        return 'Pending';
    }
  }

  bool get isUsable => this == WalletStatus.active;
}
