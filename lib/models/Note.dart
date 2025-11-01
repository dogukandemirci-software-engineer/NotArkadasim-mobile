// lib/models/Note.dart
class Note {
  final String id;
  final String title;
  final String description;
  final String owner;
  final String language;
  final String pdfPath;
  final List<String> hashtags;
  final bool isPopular;
  final String? imageUrl;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.pdfPath,
    required this.hashtags,
    required this.owner,
    this.isPopular = false,
    this.imageUrl,
  });
}