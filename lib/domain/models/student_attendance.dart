import 'attendance_type.dart';

class StudentAttendance {
  final int id;
  final int studentId;
  final String studentName;
  final DateTime attendanceDate;
  final AttendanceType attendanceType;
  final String? notes;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int? recordedBy;
  final String? recordedByName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StudentAttendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.attendanceDate,
    required this.attendanceType,
    this.notes,
    this.checkInTime,
    this.checkOutTime,
    this.recordedBy,
    this.recordedByName,
    required this.createdAt,
    this.updatedAt,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      studentName: json['studentName'] as String,
      attendanceDate: DateTime.parse(json['attendanceDate'] as String),
      attendanceType: AttendanceType.fromJson(json['attendanceType'] as String),
      notes: json['notes'] as String?,
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
      recordedBy: json['recordedBy'] as int?,
      recordedByName: json['recordedByName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'attendanceDate': attendanceDate.toIso8601String(),
      'attendanceType': attendanceType.toJson(),
      if (notes != null) 'notes': notes,
      if (checkInTime != null) 'checkInTime': checkInTime!.toIso8601String(),
      if (checkOutTime != null) 'checkOutTime': checkOutTime!.toIso8601String(),
      if (recordedBy != null) 'recordedBy': recordedBy,
      if (recordedByName != null) 'recordedByName': recordedByName,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Duration? get timeSpent {
    if (checkInTime != null && checkOutTime != null) {
      return checkOutTime!.difference(checkInTime!);
    }
    return null;
  }

  StudentAttendance copyWith({
    int? id,
    int? studentId,
    String? studentName,
    DateTime? attendanceDate,
    AttendanceType? attendanceType,
    String? notes,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    int? recordedBy,
    String? recordedByName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentAttendance(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      attendanceType: attendanceType ?? this.attendanceType,
      notes: notes ?? this.notes,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      recordedBy: recordedBy ?? this.recordedBy,
      recordedByName: recordedByName ?? this.recordedByName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
