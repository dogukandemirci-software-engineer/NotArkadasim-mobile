
import 'dart:collection';

import 'package:note_arkadasim/models/global_api_handler_result.dart';
import 'package:note_arkadasim/models/global_api_handler_result_status_codes.dart';

class GlobalApiHandler {
  Queue<GlobalApiHandlerResult> results = Queue<GlobalApiHandlerResult>();

  final int maxResults = 10;

  void addResult(GlobalApiHandlerResult newResult) {
    results.add(newResult);
    // Eğer sınır aşılırsa en baştaki (en eski) elemanı çıkar
    if (results.length > maxResults) {
      results.removeFirst();
    }
  }

  void trigger() {
    if (results.isNotEmpty) {
      final firstResult = results.last;
      if (
      firstResult.global_api_handler_result_status_code == GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_ERROR
      ||
      firstResult.global_api_handler_result_status_code == GLOBAL_API_HANDLER_RESULT_STATUS_CODE.CONNECTION_TIMEOUT
      ) {
        action(firstResult.global_api_handler_result_status_code.toString(), firstResult.message ?? "");
      }
      results.removeLast();
    }
  }

  void action(String resultCode , String message) {
    print(resultCode + message);
  }

}