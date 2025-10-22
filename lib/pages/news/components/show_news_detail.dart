

import 'package:flutter/material.dart';

import '../models/news_model.dart';

void showNewsDetail(News news,BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        news.imageUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              height: 220,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      news.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            size: 16, color: Color(0xFF6B7385)),
                        const SizedBox(width: 6),
                        Text(
                          news.author,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: const Color(0xFF6B7385),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time,
                            size: 16, color: Color(0xFF6B7385)),
                        const SizedBox(width: 6),
                        Text(
                          _getTimeAgo(news.publishDate),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: const Color(0xFF6B7385),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      news.fullContent,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _getTimeAgo(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} gün önce';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} saat önce';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} dakika önce';
  } else {
    return 'Az önce';
  }
}