import 'package:note_arkadasim/validation/validation_result.dart';

import 'enums/validation_field_types.dart';
import 'validator.dart';

String? validatePassword(String? value) {
  final passwordValidator = Validator(FieldType.password);
  ValidationResult result = passwordValidator.validate(value);
  if (value == null || !passwordValidator.validate(value).isValid) {
    return result.errorMessage;
  }
  return null;
}
