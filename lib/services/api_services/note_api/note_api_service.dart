import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:note_arkadasim/models/note_add_model.dart';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:note_arkadasim/services/api_services/dio_client.dart';
import 'package:note_arkadasim/services/api_services/note_api/constants/fake_constants.dart';
import '../../../models/Note.dart';

class NoteApiService {
  static late final NoteApiService _instance = NoteApiService._internal();

  NoteApiService._internal();

  static NoteApiService get instance => _instance;

  int lastPageCount = 0;
  final dio = DioClient().dio; // Burada DioClient kullanılıyor

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

  Future<bool> addNote(NoteAddModel note) async {
    try {
      final Map<String, dynamic> dataMap = {
        'title': note.title,
        'description': note.description,
        'isPublic': note.isPublic,
        'isComment': note.isComment,
        'languageId': note.languageId,
        'lectureId': note.lectureId,
        'tagIds': note.tagIds,
      };

      if (note.noteFile.path != null) {
        dataMap['noteFile'] = await MultipartFile.fromFile(
          note.noteFile.path!,
          filename: note.noteFile.path!.split('/').last,
        );
      } else {
        throw Exception("PDF file path is null.");
      }

      if (note.noteCoverimage != null && note.noteCoverimage!.path != null) {
        dataMap['noteCoverImage'] = await MultipartFile.fromFile(
          note.noteCoverimage!.path!,
          filename: note.noteCoverimage!.path!.split('/').last,
        );
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dio.post(
        '${BaseApi.ip}/note/create',
        data: formData,
        // Authorization header'ı DioClient interceptor tarafından otomatik eklenecek
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding note: $e');
      return false;
    }
  }

  void resetPagination() {
    lastPageCount = 0;
  }
}
