class Page {
  static const int defaultPageNumber = 1;
  static const int defaultPageSize = 10;

  final int pageNumber;
  final int pageSize;
  final int totalRowCount;
  final String? searchTerm;
  final String? sortBy;
  final bool sortDescending;

  Page({
    int? pageNumber,
    int? pageSize,
    this.totalRowCount = 0,
    this.searchTerm,
    this.sortBy,
    this.sortDescending = false,
  })  : pageNumber = (pageNumber ?? defaultPageNumber) < 1
      ? defaultPageNumber
      : (pageNumber ?? defaultPageNumber),
        pageSize = (pageSize ?? defaultPageSize) < 1
            ? defaultPageSize
            : (pageSize ?? defaultPageSize);

  int get totalPageCount => (totalRowCount / pageSize).ceil();
  int get skip => (pageNumber - 1) * pageSize;
  bool get hasNextPage => pageNumber < totalPageCount;
  bool get hasPreviousPage => pageNumber > 1;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    pageNumber: json['pageNumber'],
    pageSize: json['pageSize'],
    totalRowCount: json['totalRowCount'] ?? 0,
    searchTerm: json['searchTerm'],
    sortBy: json['sortBy'],
    sortDescending: json['sortDescending'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'totalRowCount': totalRowCount,
    'totalPageCount': totalPageCount,
    'skip': skip,
    'hasNextPage': hasNextPage,
    'hasPreviousPage': hasPreviousPage,
    if (searchTerm != null) 'searchTerm': searchTerm,
    if (sortBy != null) 'sortBy': sortBy,
    'sortDescending': sortDescending,
  };

  Map<String, dynamic> toQueryParameters() => {
    'pageNumber': pageNumber.toString(),
    'pageSize': pageSize.toString(),
    if (searchTerm?.isNotEmpty ?? false) 'searchTerm': searchTerm!,
    if (sortBy?.isNotEmpty ?? false) 'sortBy': sortBy!,
    'sortDescending': sortDescending.toString(),
  };

  Page copyWith({
    int? pageNumber,
    int? pageSize,
    int? totalRowCount,
    String? searchTerm,
    String? sortBy,
    bool? sortDescending,
  }) =>
      Page(
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        totalRowCount: totalRowCount ?? this.totalRowCount,
        searchTerm: searchTerm ?? this.searchTerm,
        sortBy: sortBy ?? this.sortBy,
        sortDescending: sortDescending ?? this.sortDescending,
      );
}
