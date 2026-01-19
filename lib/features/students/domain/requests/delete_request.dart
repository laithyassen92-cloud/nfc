class DeleteRequest {
  final int id;
  final String? reason;

  DeleteRequest({required this.id, this.reason});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }

  factory DeleteRequest.fromJson(Map<String, dynamic> json) {
    return DeleteRequest(
      id: json['id'] as int,
      reason: json['reason'] as String?,
    );
  }

  DeleteRequest copyWith({int? id, String? reason}) {
    return DeleteRequest(id: id ?? this.id, reason: reason ?? this.reason);
  }
}
