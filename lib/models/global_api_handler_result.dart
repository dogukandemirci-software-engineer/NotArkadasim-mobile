
import 'package:note_arkadasim/models/global_api_handler_result_status_codes.dart';

class GlobalApiHandlerResult {
  late GLOBAL_API_HANDLER_RESULT_STATUS_CODE global_api_handler_result_status_code;
  String? message = "";
  dynamic data;
  GlobalApiHandlerResult({
    global_api_handler_result_status_code,
    message,
    data
  });
}