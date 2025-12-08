import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_classic_appbar/NA_classic_appbar.dart';
import 'package:note_arkadasim/routes/routes.dart';

import '../../../../services/navigation_service/navigation_service.dart';


class MyNotesPage extends StatelessWidget {
  const MyNotesPage({super.key});


  static const _myNotes = [
    {'title': 'Kendi Notum 1', 'desc': 'Kısa açıklama 1'},
    {'title': 'Kendi Notum 2', 'desc': 'Kısa açıklama 2'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "My Notes"),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => NavigationService.instance.go(AppRoutes.addNote),
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _myNotes.length,
        itemBuilder: (context, i) {
          final n = _myNotes[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(n['title']!),
              subtitle: Text(n['desc']!),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') NavigationService.instance.go(AppRoutes.addNote, arguments: {'edit': i});
                  if (v == 'delete') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted (mock)')));
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
              onTap: () => NavigationService.instance.go(AppRoutes.notes, arguments: {'noteIndex': i}),
            ),
          );
        },
      ),
    );
  }
}