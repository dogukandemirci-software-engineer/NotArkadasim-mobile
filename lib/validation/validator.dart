import 'package:note_arkadasim/validation/validation_result.dart';

import 'constants/validation_rules.dart';
import 'base_validation.dart';
import 'enums/validation_field_types.dart';

class Validator implements IBaseValidation {
  final FieldType fieldType;

  Validator(this.fieldType);

  @override
  ValidationResult validate(String? input) {
    ValidationResult validationResult = ValidationResult(false , null);
    if (input == null) {
      validationResult.isValid = false;
      validationResult.errorMessage = "Bu ${fieldType.toString()} gereklidir";
      return validationResult;
    };

    final rule = validationRules[fieldType];
    if (rule == null) {
      validationResult.isValid = false;
      validationResult.errorMessage = "Bu ${fieldType.toString()} gereklidir";
      return validationResult;
    };

    final regexPattern = rule["regex"] as String;
    final maxLength = rule["characterLength"] as int;
    final minLenght = rule["minLenght"] as int;

    final regExp = regexPattern.isNotEmpty ? RegExp(regexPattern) : null;

    if (input.length > maxLength && input.length < minLenght) {
      validationResult.isValid = false;
      validationResult.errorMessage = rule["lenghtError"] as String;
      return validationResult;
    }

    if (regExp != null && !regExp.hasMatch(input)) {
      validationResult.isValid = false;
      validationResult.errorMessage = rule["generalError"] as String;
      return validationResult;
    }

    return ValidationResult(true, null);
  }
}
