import 'package:note_arkadasim/validation/validation_result.dart';

import 'enums/validation_field_types.dart';
import 'validator.dart';

String? validateSurname(String? value) {
  final surnameValidator = Validator(FieldType.surname);
  final result = surnameValidator.validate(value);
  if (!result.isValid) return result.errorMessage;
  return null;
}
