class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String fullContent;
  final DateTime publishDate;
  final String author;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.fullContent,
    required this.publishDate,
    required this.author,
  });
}