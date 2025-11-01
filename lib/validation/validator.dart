import 'package:note_arkadasim/validation/validation_result.dart';

import 'constants/validation_rules.dart';
import 'base_validation.dart';
import 'enums/validation_field_types.dart';

class Validator implements IBaseValidation {
  final FieldType fieldType;

  Validator(this.fieldType);

  @override
  ValidationResult validate(String? input) {
    if (input == null || input.trim().isEmpty) {
      return ValidationResult(false, "Bu alan gereklidir");
    }

    final rule = validationRules[fieldType];
    if (rule == null) {
      return ValidationResult(false, "Geçersiz alan");
    }

    final regexPattern = rule["regex"] as String? ?? '';
    final maxLength = rule["characterLength"] as int;
    final minLenght = rule["minLenght"] as int;

    // Daha gerçekçi: min veya max ihlali -> hata
    if (input.length > maxLength || input.length < minLenght) {
      return ValidationResult(false, rule["lenghtError"] as String);
    }

    // Eğer regex boş değilse kontrol et
    if (regexPattern.isNotEmpty) {
      final regExp = RegExp(regexPattern);
      if (!regExp.hasMatch(input)) {
        return ValidationResult(false, rule["generalError"] as String);
      }
    }

    return ValidationResult(true, null);
  }
}
