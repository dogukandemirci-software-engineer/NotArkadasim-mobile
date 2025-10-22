import 'package:note_arkadasim/validation/validation_result.dart';
import '../../../../validation/enums/validation_field_types.dart';
import '../../../../validation/validator.dart';

String? validateName(String? value) {
  final nameValidator = Validator(FieldType.name);
  ValidationResult result = nameValidator.validate(value);
  if (value == null || !nameValidator.validate(value).isValid) {
    return result.errorMessage;
  }
  return null;
}
