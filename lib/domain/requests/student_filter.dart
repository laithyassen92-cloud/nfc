class StudentFilter {
  final String? searchTerm;
  final String? gradeLevel;
  final String? classRoom;
  final int? guardianId;
  final bool? isActive;
  final int pageNumber;
  final int pageSize;
  final String? sortBy;
  final bool sortDescending;

  StudentFilter({
    this.searchTerm,
    this.gradeLevel,
    this.classRoom,
    this.guardianId,
    this.isActive,
    this.pageNumber = 1,
    this.pageSize = 20,
    this.sortBy,
    this.sortDescending = false,
  });

  Map<String, dynamic> toJson() {
    return {
      if (searchTerm != null && searchTerm!.isNotEmpty)
        'searchTerm': searchTerm,
      if (gradeLevel != null) 'gradeLevel': gradeLevel,
      if (classRoom != null) 'classRoom': classRoom,
      if (guardianId != null) 'guardianId': guardianId,
      if (isActive != null) 'isActive': isActive,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (sortBy != null) 'sortBy': sortBy,
      'sortDescending': sortDescending,
    };
  }

  Map<String, String> toQueryParams() {
    return {
      if (searchTerm != null && searchTerm!.isNotEmpty)
        'searchTerm': searchTerm!,
      if (gradeLevel != null) 'gradeLevel': gradeLevel!,
      if (classRoom != null) 'classRoom': classRoom!,
      if (guardianId != null) 'guardianId': guardianId.toString(),
      if (isActive != null) 'isActive': isActive.toString(),
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      if (sortBy != null) 'sortBy': sortBy!,
      'sortDescending': sortDescending.toString(),
    };
  }

  factory StudentFilter.fromJson(Map<String, dynamic> json) {
    return StudentFilter(
      searchTerm: json['searchTerm'] as String?,
      gradeLevel: json['gradeLevel'] as String?,
      classRoom: json['classRoom'] as String?,
      guardianId: json['guardianId'] as int?,
      isActive: json['isActive'] as bool?,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      sortBy: json['sortBy'] as String?,
      sortDescending: json['sortDescending'] as bool? ?? false,
    );
  }

  StudentFilter copyWith({
    String? searchTerm,
    String? gradeLevel,
    String? classRoom,
    int? guardianId,
    bool? isActive,
    int? pageNumber,
    int? pageSize,
    String? sortBy,
    bool? sortDescending,
  }) {
    return StudentFilter(
      searchTerm: searchTerm ?? this.searchTerm,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      classRoom: classRoom ?? this.classRoom,
      guardianId: guardianId ?? this.guardianId,
      isActive: isActive ?? this.isActive,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }
}
