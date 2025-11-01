import 'package:note_arkadasim/validation/validation_result.dart';

import 'enums/validation_field_types.dart';
import 'validator.dart';

String? validatePassword(String? value) {
  final passwordValidator = Validator(FieldType.password);
  final result = passwordValidator.validate(value);

  // Eğer geçersizse errorMessage döndür, geçerliyse null
  if (!result.isValid) {
    return result.errorMessage;
  }
  return null;
}
