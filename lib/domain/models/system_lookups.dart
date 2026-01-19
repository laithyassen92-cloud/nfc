class SystemLookups {
  final List<LookupItem> gradeLevels;
  final List<LookupItem> classRooms;
  final List<LookupItem> relationships;
  final List<LookupItem> paymentMethods;
  final List<LookupItem> transactionPurposes;

  SystemLookups({
    required this.gradeLevels,
    required this.classRooms,
    required this.relationships,
    required this.paymentMethods,
    required this.transactionPurposes,
  });

  factory SystemLookups.fromJson(Map<String, dynamic> json) {
    return SystemLookups(
      gradeLevels:
          (json['gradeLevels'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      classRooms:
          (json['classRooms'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      relationships:
          (json['relationships'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      paymentMethods:
          (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      transactionPurposes:
          (json['transactionPurposes'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gradeLevels': gradeLevels.map((e) => e.toJson()).toList(),
      'classRooms': classRooms.map((e) => e.toJson()).toList(),
      'relationships': relationships.map((e) => e.toJson()).toList(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'transactionPurposes': transactionPurposes
          .map((e) => e.toJson())
          .toList(),
    };
  }

  SystemLookups copyWith({
    List<LookupItem>? gradeLevels,
    List<LookupItem>? classRooms,
    List<LookupItem>? relationships,
    List<LookupItem>? paymentMethods,
    List<LookupItem>? transactionPurposes,
  }) {
    return SystemLookups(
      gradeLevels: gradeLevels ?? this.gradeLevels,
      classRooms: classRooms ?? this.classRooms,
      relationships: relationships ?? this.relationships,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      transactionPurposes: transactionPurposes ?? this.transactionPurposes,
    );
  }
}

class LookupItem {
  final String key;
  final String value;
  final String? displayName;
  final bool isActive;

  LookupItem({
    required this.key,
    required this.value,
    this.displayName,
    this.isActive = true,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      key: json['key'] as String,
      value: json['value'] as String,
      displayName: json['displayName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      if (displayName != null) 'displayName': displayName,
      'isActive': isActive,
    };
  }

  String get display => displayName ?? value;

  LookupItem copyWith({
    String? key,
    String? value,
    String? displayName,
    bool? isActive,
  }) {
    return LookupItem(
      key: key ?? this.key,
      value: value ?? this.value,
      displayName: displayName ?? this.displayName,
      isActive: isActive ?? this.isActive,
    );
  }
}
