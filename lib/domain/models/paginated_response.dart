class PaginatedResponse<T> {
  final List<T> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList =
        (json['data'] as List<dynamic>?)
            ?.map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse(
      data: dataList,
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginatedResponse(
      data: data ?? this.data,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }
}
