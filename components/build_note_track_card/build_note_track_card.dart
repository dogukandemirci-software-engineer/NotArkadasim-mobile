import 'package:flutter/material.dart';
import '../../services/storage_services/note_tracking_service.dart';

class NoteTrackCard extends StatefulWidget {
  const NoteTrackCard({super.key});

  @override
  State<NoteTrackCard> createState() => _NoteTrackCardState();
}

class _NoteTrackCardState extends State<NoteTrackCard> {
  final NoteTrackingService _service = NoteTrackingService();
  late Future<int> _futureCount;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  void _loadCount() {
    _futureCount = _service.loadNoteCountToday();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _futureCount,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.deepPurpleAccent.withOpacity(0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.edit_note_outlined,
                  size: 28,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bugün eklenen notlar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$count not",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
