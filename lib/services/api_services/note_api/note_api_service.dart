
import 'package:dio/dio.dart';
import 'package:note_arkadasim/models/global_api_handler_result.dart';
import 'package:note_arkadasim/models/global_api_handler_result_status_codes.dart';
import 'package:note_arkadasim/models/note_add_model.dart';
import 'package:note_arkadasim/models/note_paging_request.dart';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:note_arkadasim/services/api_services/dio_client.dart';
import '../../../models/note_entity.dart';

class NoteApiService {
  static late final NoteApiService _instance = NoteApiService._internal();

  NoteApiService._internal();

  static NoteApiService get instance => _instance;

  int lastPageCount = 0;
  final dio = DioClient().dio; // Burada DioClient kullanılıyor

  Future<GlobalApiHandlerResult> getNoteByPagination(NotePagingRequest notePagingRequest) async {
    final String urlPath = "${BaseApi.ip}/note/getPage";

    // Varsayılan hata nesnesi
    final result = GlobalApiHandlerResult(
      global_api_handler_result_status_code: GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_ERROR,
      message: "Beklenmedik bir hata oluştu",
    );

    try {
      final response = await dio.post(
        urlPath,
        data: notePagingRequest.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        // 1. JSON verisini NoteResponse modeline dönüştürüyoruz
        final noteResponse = NoteResponse.fromJson(response.data);

        // 2. İşlem başarılıysa result nesnesini güncelliyoruz
        if (noteResponse.meta.isSuccess) {
          result.global_api_handler_result_status_code = GLOBAL_API_HANDLER_RESULT_STATUS_CODE.SUCCESS;
          result.data = noteResponse; // result içinde 'data' alanı olduğunu varsayıyorum
          result.message = noteResponse.meta.message ?? "İşlem Başarılı";
        } else {
          // API'den false dönen isSuccess durumu (örn: validasyon hatası)
          result.global_api_handler_result_status_code = GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_ERROR;
          result.message = noteResponse.meta.errorMessages?.join(", ") ?? "Bir hata oluştu";
        }
      } else {
        result.global_api_handler_result_status_code = GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_TIMEOUT;
        result.message = "Sunucu hatası: ${response.statusCode}";
      }
    } catch (e) {
      result.global_api_handler_result_status_code = GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_ERROR;
      result.message = "Hata: $e";
    }

    return result;
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
