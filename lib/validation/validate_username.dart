import 'package:note_arkadasim/validation/validation_result.dart';

import 'enums/validation_field_types.dart';
import 'validator.dart';

String? validateUsername(String? value) {
  final usernameValidator = Validator(FieldType.username);
  final result = usernameValidator.validate(value);

  if (!result.isValid) {
    return result.errorMessage;
  }
  return null;
}
