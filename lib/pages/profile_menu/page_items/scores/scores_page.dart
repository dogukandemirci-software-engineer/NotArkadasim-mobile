import 'package:flutter/material.dart';

class ScoresPage extends StatelessWidget {
  const ScoresPage({super.key});


  static const _leaderboard = [
    {'user': 'Doğukan', 'score': '1520'},
    {'user': 'Elif', 'score': '1400'},
    {'user': 'Mehmet', 'score': '1310'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scores')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Your Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('1520', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _leaderboard.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final row = _leaderboard[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(row['user']![0])),
                    title: Text(row['user']!),
                    trailing: Text(row['score']!),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}