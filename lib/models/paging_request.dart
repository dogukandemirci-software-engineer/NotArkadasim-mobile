class PagingRequest {
  int pageNumber;
  int pageSize;

  PagingRequest({
    this.pageNumber = 1, // Sayfa genelde 1'den başlar
    this.pageSize = 10,  // Varsayılan bir sayfa boyutu
  });

  // Nesneyi JSON formatına (Map) çevirir
  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }

  // JSON'dan (Map) nesne oluşturur
  factory PagingRequest.fromJson(Map<String, dynamic> json) {
    return PagingRequest(
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
    );
  }
}