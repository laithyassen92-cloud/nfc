class SaveStudentRequest {
  final int? studentId; // null for create, non-null for update
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final String gender; // Male, Female
  final String gradeLevel;
  final String? classRoom;
  final int? guardianId;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? nationalId;
  final String? photoUrl;
  final bool isActive;

  SaveStudentRequest({
    this.studentId,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.dateOfBirth,
    required this.gender,
    required this.gradeLevel,
    this.classRoom,
    this.guardianId,
    this.phoneNumber,
    this.email,
    this.address,
    this.nationalId,
    this.photoUrl,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      if (studentId != null) 'studentId': studentId,
      'firstName': firstName,
      'lastName': lastName,
      if (middleName != null) 'middleName': middleName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'gradeLevel': gradeLevel,
      if (classRoom != null) 'classRoom': classRoom,
      if (guardianId != null) 'guardianId': guardianId,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (nationalId != null) 'nationalId': nationalId,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'isActive': isActive,
    };
  }

  factory SaveStudentRequest.fromJson(Map<String, dynamic> json) {
    return SaveStudentRequest(
      studentId: json['studentId'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      gradeLevel: json['gradeLevel'] as String,
      classRoom: json['classRoom'] as String?,
      guardianId: json['guardianId'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      nationalId: json['nationalId'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  SaveStudentRequest copyWith({
    int? studentId,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    String? gender,
    String? gradeLevel,
    String? classRoom,
    int? guardianId,
    String? phoneNumber,
    String? email,
    String? address,
    String? nationalId,
    String? photoUrl,
    bool? isActive,
  }) {
    return SaveStudentRequest(
      studentId: studentId ?? this.studentId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      classRoom: classRoom ?? this.classRoom,
      guardianId: guardianId ?? this.guardianId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
