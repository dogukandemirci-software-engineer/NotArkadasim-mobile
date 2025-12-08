import 'dart:io';

class NoteAddModel {
  final String title;
  final String description;
  final bool isPublic;
  final bool isComment;
  final File? noteCoverimage;
  final File noteFile;
  final List<String> tagIds;
  final String languageId;
  final String lectureId;

  NoteAddModel({
    required this.title,
    required this.description,
    required this.isPublic,
    required this.isComment,
    this.noteCoverimage,
    required this.noteFile,
    required this.tagIds,
    required this.languageId,
    required this.lectureId,
  });
}
