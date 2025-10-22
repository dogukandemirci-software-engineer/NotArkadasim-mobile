import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  // Fake comment verisi
  final List<Map<String, String>> _comments = const [
    {
      'user': 'Ayşe Yılmaz',
      'comment': 'Bu not çok faydalı oldu, teşekkürler!',
      'date': '2025-10-21',
    },
    {
      'user': 'Mehmet Can',
      'comment': 'Biraz daha detay eklenebilir.',
      'date': '2025-10-20',
    },
    {
      'user': 'Elif Kara',
      'comment': 'Güzel paylaşım 👍',
      'date': '2025-10-18',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          final comment = _comments[index];
          return _buildCommentCard(comment);
        },
      ),
    );
  }

  Widget _buildCommentCard(Map<String, String> comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment['user'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              comment['comment'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                comment['date'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
