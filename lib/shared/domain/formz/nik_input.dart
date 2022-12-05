import 'package:formz/formz.dart';

enum NikValidationError { invalid, subceedingLength, exceedingLength }

class NikInput extends FormzInput<String, NikValidationError> {
  const NikInput.pure([super.value = '']) : super.pure();
  const NikInput.dirty([super.value = '']) : super.dirty();
  static final regexPhone = RegExp(
    r'^[0-9]+$',
  );

  static const minimumLength = 16;
  static const maximumLength = 16;
  @override
  NikValidationError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (!regexPhone.hasMatch(value)) {
      return NikValidationError.invalid;
    }

    if (value.length < minimumLength) {
      return NikValidationError.subceedingLength;
    }
    if (value.length > maximumLength) {
      return NikValidationError.exceedingLength;
    }

    return null;
  }
}

extension NikValidationErrorX on NikValidationError {
  String description() {
    switch (this) {
      case NikValidationError.invalid:
        return 'NIK tidak valid';
      case NikValidationError.subceedingLength:
        return 'NIK minimal 16 karakter';
      case NikValidationError.exceedingLength:
        return 'NIK maksimal 16 karakter';
    }
  }
}
