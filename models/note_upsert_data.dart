import 'package:note_arkadasim/models/lecture.dart';
import 'package:note_arkadasim/models/language.dart';
import 'package:note_arkadasim/models/tag.dart';

class NoteUpsertData {
  final List<Lecture> lectures;
  final List<Language> languages;
  final List<Tag> tags;

  NoteUpsertData({
    required this.lectures,
    required this.languages,
    required this.tags,
  });

  factory NoteUpsertData.fromJson(Map<String, dynamic> json) {
    return NoteUpsertData(
      lectures: (json['lectures'] as List)
          .map((i) => Lecture.fromJson(i))
          .toList(),
      languages: (json['languages'] as List)
          .map((i) => Language.fromJson(i))
          .toList(),
      tags: (json['tags'] as List).map((i) => Tag.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lectures': lectures.map((i) => i.toJson()).toList(),
      'languages': languages.map((i) => i.toJson()).toList(),
      'tags': tags.map((i) => i.toJson()).toList(),
    };
  }
}
