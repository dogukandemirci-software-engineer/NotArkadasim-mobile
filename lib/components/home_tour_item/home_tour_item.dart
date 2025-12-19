import 'package:flutter/material.dart';
import '../../models/home_tour_item.dart';

class HomeTourCard extends StatelessWidget {
  final HomeTourItem item;

  const HomeTourCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.purple.withOpacity(0.08), // çok hafif
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 44, // daha büyük
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
