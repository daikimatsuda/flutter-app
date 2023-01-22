import 'package:flutter_dev/constant/strings.dart';
import 'package:flutter_dev/validator/validator.dart';

class MaxLengthValidator implements Validator<String> {
  final int maxLength;

  MaxLengthValidator(this.maxLength);

  @override
  bool validate(value) => value.length <= maxLength;

  @override
  String getMessage() => '$maxLength${Strings.maxLengthValidatorMessage}';
}