import 'dart:async';
import 'package:note_arkadasim/services/api_services/note_api/constants/fake_constants.dart';
import '../../../models/Note.dart';

class NoteApiService {
  static late final NoteApiService _instance = NoteApiService._internal();

  NoteApiService._internal();

  static NoteApiService get instance => _instance;

  int lastPageCount = 0;

  Future<List<Note>> getNotesByPage() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (lastPageCount >= notes.length) return [];

    final nextCount = (lastPageCount + 9 > notes.length)
        ? notes.length
        : lastPageCount + 9;

    final pagedNotes = notes.sublist(lastPageCount, nextCount);
    lastPageCount = nextCount;

    return pagedNotes;
  }

  void resetPagination() {
    lastPageCount = 0;
  }

}