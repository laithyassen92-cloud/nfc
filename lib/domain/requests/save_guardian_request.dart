class SaveGuardianRequest {
  final int? guardianId; // null for create, non-null for update
  final String firstName;
  final String lastName;
  final String? middleName;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? nationalId;
  final String relationshipToStudent; // Father, Mother, Guardian, etc.
  final bool isPrimaryContact;
  final String? photoUrl;

  SaveGuardianRequest({
    this.guardianId,
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
  });

  Map<String, dynamic> toJson() {
    return {
      if (guardianId != null) 'guardianId': guardianId,
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
    };
  }

  factory SaveGuardianRequest.fromJson(Map<String, dynamic> json) {
    return SaveGuardianRequest(
      guardianId: json['guardianId'] as int?,
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
    );
  }

  SaveGuardianRequest copyWith({
    int? guardianId,
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
  }) {
    return SaveGuardianRequest(
      guardianId: guardianId ?? this.guardianId,
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
    );
  }
}
