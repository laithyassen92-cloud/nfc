class GetStudentAttendanceRequest {
  final int? studentId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? attendanceType;
  final int pageNumber;
  final int pageSize;

  GetStudentAttendanceRequest({
    this.studentId,
    this.fromDate,
    this.toDate,
    this.attendanceType,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      if (studentId != null) 'studentId': studentId,
      if (fromDate != null) 'fromDate': fromDate!.toIso8601String(),
      if (toDate != null) 'toDate': toDate!.toIso8601String(),
      if (attendanceType != null) 'attendanceType': attendanceType,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }

  factory GetStudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    return GetStudentAttendanceRequest(
      studentId: json['studentId'] as int?,
      fromDate: json['fromDate'] != null
          ? DateTime.parse(json['fromDate'] as String)
          : null,
      toDate: json['toDate'] != null
          ? DateTime.parse(json['toDate'] as String)
          : null,
      attendanceType: json['attendanceType'] as String?,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
    );
  }

  GetStudentAttendanceRequest copyWith({
    int? studentId,
    DateTime? fromDate,
    DateTime? toDate,
    String? attendanceType,
    int? pageNumber,
    int? pageSize,
  }) {
    return GetStudentAttendanceRequest(
      studentId: studentId ?? this.studentId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      attendanceType: attendanceType ?? this.attendanceType,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
