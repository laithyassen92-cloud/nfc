enum AttendanceType {
  present,
  absent,
  late,
  excused,
  halfDay;

  String toJson() => name;

  static AttendanceType fromJson(String value) {
    return AttendanceType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttendanceType.absent,
    );
  }

  String get displayName {
    switch (this) {
      case AttendanceType.present:
        return 'Present';
      case AttendanceType.absent:
        return 'Absent';
      case AttendanceType.late:
        return 'Late';
      case AttendanceType.excused:
        return 'Excused';
      case AttendanceType.halfDay:
        return 'Half Day';
    }
  }
}
