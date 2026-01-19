class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String? middleName;
  final DateTime dateOfBirth;
  final String gender;
  final String gradeLevel;
  final String? classRoom;
  final int? guardianId;
  final String? guardianName;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? nationalId;
  final String? photoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.dateOfBirth,
    required this.gender,
    required this.gradeLevel,
    this.classRoom,
    this.guardianId,
    this.guardianName,
    this.phoneNumber,
    this.email,
    this.address,
    this.nationalId,
    this.photoUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      gradeLevel: json['gradeLevel'] as String,
      classRoom: json['classRoom'] as String?,
      guardianId: json['guardianId'] as int?,
      guardianName: json['guardianName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      nationalId: json['nationalId'] as String?,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool,
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
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'gradeLevel': gradeLevel,
      if (classRoom != null) 'classRoom': classRoom,
      if (guardianId != null) 'guardianId': guardianId,
      if (guardianName != null) 'guardianName': guardianName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (nationalId != null) 'nationalId': nationalId,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'isActive': isActive,
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

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  Student copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? dateOfBirth,
    String? gender,
    String? gradeLevel,
    String? classRoom,
    int? guardianId,
    String? guardianName,
    String? phoneNumber,
    String? email,
    String? address,
    String? nationalId,
    String? photoUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      classRoom: classRoom ?? this.classRoom,
      guardianId: guardianId ?? this.guardianId,
      guardianName: guardianName ?? this.guardianName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
