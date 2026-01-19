class SaveStudentAttendanceRequest {
  final int studentId;
  final DateTime attendanceDate;
  final String attendanceType; // AttendanceType enum value
  final String? notes;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  SaveStudentAttendanceRequest({
    required this.studentId,
    required this.attendanceDate,
    required this.attendanceType,
    this.notes,
    this.checkInTime,
    this.checkOutTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'attendanceDate': attendanceDate.toIso8601String(),
      'attendanceType': attendanceType,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (checkInTime != null) 'checkInTime': checkInTime!.toIso8601String(),
      if (checkOutTime != null) 'checkOutTime': checkOutTime!.toIso8601String(),
    };
  }

  factory SaveStudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    return SaveStudentAttendanceRequest(
      studentId: json['studentId'] as int,
      attendanceDate: DateTime.parse(json['attendanceDate'] as String),
      attendanceType: json['attendanceType'] as String,
      notes: json['notes'] as String?,
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
    );
  }

  SaveStudentAttendanceRequest copyWith({
    int? studentId,
    DateTime? attendanceDate,
    String? attendanceType,
    String? notes,
    DateTime? checkInTime,
    DateTime? checkOutTime,
  }) {
    return SaveStudentAttendanceRequest(
      studentId: studentId ?? this.studentId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      attendanceType: attendanceType ?? this.attendanceType,
      notes: notes ?? this.notes,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
    );
  }
}
