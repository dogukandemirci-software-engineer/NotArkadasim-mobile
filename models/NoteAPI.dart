import 'dart:convert';

class NoteAPI {
  final String title;
  final String description;
  final bool isPublic;
  final bool isComment;
  final String NoteAPICoverimage; // File için base64 ya da dosya yolu olarak string
  final String NoteAPIFile;       // File için base64 ya da dosya yolu olarak string
  final String tagIds;
  final String languageId;
  final String lecturedd;

  NoteAPI({
    required this.title,
    required this.description,
    required this.isPublic,
    required this.isComment,
    required this.NoteAPICoverimage,
    required this.NoteAPIFile,
    required this.tagIds,
    required this.languageId,
    required this.lecturedd,
  });

  factory NoteAPI.fromJson(Map<String, dynamic> json) {
    return NoteAPI(
      title: json['title'] as String,
      description: json['description'] as String,
      isPublic: json['isPublic'] as bool,
      isComment: json['isComment'] as bool,
      NoteAPICoverimage: json['NoteAPICoverimage'] as String,
      NoteAPIFile: json['NoteAPIFile'] as String,
      tagIds: json['tagIds'] as String,
      languageId: json['languageId'] as String,
      lecturedd: json['lecturedd'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isPublic': isPublic,
      'isComment': isComment,
      'NoteAPICoverimage': NoteAPICoverimage,
      'NoteAPIFile': NoteAPIFile,
      'tagIds': tagIds,
      'languageId': languageId,
      'lecturedd': lecturedd,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static NoteAPI fromJsonString(String jsonString) =>
      NoteAPI.fromJson(jsonDecode(jsonString));
}
