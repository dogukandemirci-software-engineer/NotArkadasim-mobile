import 'package:note_arkadasim/models/paging_request.dart';

class NotePagingRequest {
  PagingRequest pagingRequest;
  int minRating;
  int sortBy;
  String? searchText;
  List<String> tagIds;
  List<String> lectureIds;
  List<String> languageIds;
  List<String> universityIds;

  NotePagingRequest({
    required this.pagingRequest,
    this.minRating = 0,
    this.sortBy = 1,
    this.searchText = "",
    this.tagIds = const [],
    this.lectureIds = const [],
    this.languageIds = const [],
    this.universityIds = const [],
  });

  // Nesneyi Map (JSON) yapısına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'pagingRequest': pagingRequest.toJson(), // PagingRequest sınıfında toJson olmalı
      'minRating': minRating,
      'sortBy': sortBy,
      'searchText': searchText,
      'tagIds': tagIds,
      'lectureIds': lectureIds,
      'languageIds': languageIds,
      'universityIds': universityIds,
    };
  }

  // JSON'dan (Map) nesne oluşturur
  factory NotePagingRequest.fromJson(Map<String, dynamic> json) {
    return NotePagingRequest(
      pagingRequest: PagingRequest.fromJson(json['pagingRequest']),
      minRating: json['minRating'] ?? 0,
      sortBy: json['sortBy'] ?? 1,
      searchText: json['searchText'] ?? "",
      tagIds: List<String>.from(json['tagIds'] ?? []),
      lectureIds: List<String>.from(json['lectureIds'] ?? []),
      languageIds: List<String>.from(json['languageIds'] ?? []),
      universityIds: List<String>.from(json['universityIds'] ?? []),
    );
  }
}