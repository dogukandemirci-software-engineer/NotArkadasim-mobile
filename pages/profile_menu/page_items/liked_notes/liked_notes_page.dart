import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';
import 'package:note_arkadasim/routes/routes.dart';

import '../../../../services/navigation_service/navigation_service.dart';

class LikedNotesPage extends StatelessWidget {
  const LikedNotesPage({super.key});


  static const _mockNotes = [
    {'title': 'Flutter State Management', 'snippet': 'Provider, Bloc ve Riverpod karşılaştırması', 'owner': 'Doğukan'},
    {'title': 'Dart Tips', 'snippet': 'Immutable collection ve extension method örnekleri', 'owner': 'Elif'},
    {'title': 'Algoritma Notları', 'snippet': 'Binary search ve complexity açıklamaları', 'owner': 'Can'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Beğenilen Notlar"),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _mockNotes.length,
        itemBuilder: (context, i) {
          final n = _mockNotes[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Theme.of(context).cardColor,
              leading: const Icon(Icons.bookmark_border),
              title: Text(n['title']!),
              subtitle: Text('${n['snippet']} • ${n['owner']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                NavigationService.instance.go(AppRoutes.notes, arguments: {'noteIndex': i});
              },
            ),
          );
        },
      ),
    );
  }
}