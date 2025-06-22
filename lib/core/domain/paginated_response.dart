class PaginatedResponse<T> {
  final List<T> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      String listKey
      ) {
    final rawList = json[listKey] as List<dynamic>;
    return PaginatedResponse<T>(
      items: rawList.map((e) => fromJsonT(e as Map<String, dynamic>)).toList(),
      pageNumber: (json['pageNumber'] as num).toInt(),
      pageSize:   (json['pageSize']   as num).toInt(),
      totalCount:(json['totalCount'] as num).toInt(),
      totalPages:(json['totalPages'] as num).toInt(),
    );
  }
}
