import 'package:note_arkadasim/validation/validation_result.dart';
import 'package:note_arkadasim/validation/validator.dart';
import 'enums/validation_field_types.dart';

String? validateEmail(String? value) {
  final emailValidator = Validator(FieldType.email);
  ValidationResult result = emailValidator.validate(value);
  if (value == null || !emailValidator.validate(value).isValid) {
    return result.errorMessage;
  }
  return null;
}