enum AttachmentType {
  userPhoto,
  schoolLogo,
  studentDocument,
  guardianDocument,
  receipt,
  other;

  String toJson() => name;

  static AttachmentType fromJson(String value) {
    return AttachmentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttachmentType.other,
    );
  }
}
