class Guardian {
  final int id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? nationalId;
  final String relationshipToStudent;
  final bool isPrimaryContact;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Guardian({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.phoneNumber,
    this.email,
    this.address,
    this.nationalId,
    required this.relationshipToStudent,
    this.isPrimaryContact = true,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      nationalId: json['nationalId'] as String?,
      relationshipToStudent: json['relationshipToStudent'] as String,
      isPrimaryContact: json['isPrimaryContact'] as bool? ?? true,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      if (middleName != null) 'middleName': middleName,
      'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (nationalId != null) 'nationalId': nationalId,
      'relationshipToStudent': relationshipToStudent,
      'isPrimaryContact': isPrimaryContact,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  String get fullName {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }

  Guardian copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? middleName,
    String? phoneNumber,
    String? email,
    String? address,
    String? nationalId,
    String? relationshipToStudent,
    bool? isPrimaryContact,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Guardian(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      relationshipToStudent:
          relationshipToStudent ?? this.relationshipToStudent,
      isPrimaryContact: isPrimaryContact ?? this.isPrimaryContact,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
