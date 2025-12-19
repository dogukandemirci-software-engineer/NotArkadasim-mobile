import 'package:flutter/material.dart';

import '../../models/home_tour_item.dart';
import '../home_tour_item/home_tour_item.dart';

Widget buildHomeTourCards() {
  final items = [
    HomeTourItem(
      icon: Icons.lock_outline,
      title: "Notlarını\ngüvenle paylaş",
    ),
    HomeTourItem(
      icon: Icons.people_outline,
      title: "Arkadaşlarının\nnotlarını oku",
    ),
    HomeTourItem(
      icon: Icons.trending_up,
      title: "Kendini\ngeliştir",
    ),
    HomeTourItem(
      icon: Icons.lightbulb_outline,
      title: "Yeni fikirler\nkeşfet",
    ),
    HomeTourItem(
      icon: Icons.bookmark_outline,
      title: "Önemli\nnotları kaydet",
    ),
    HomeTourItem(
      icon: Icons.insights_outlined,
      title: "İlerlemeni\ntakip et",
    ),
  ];

  return SizedBox(
    height: 160,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return HomeTourCard(item: item);
      },
    ),
  );
}

