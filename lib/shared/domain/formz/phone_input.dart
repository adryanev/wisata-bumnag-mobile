import 'package:formz/formz.dart';

enum PhoneInputValidationError { invalid, subceedingLength, exceedingLength }

class PhoneInput extends FormzInput<String, PhoneInputValidationError> {
  const PhoneInput.pure([super.value = '']) : super.pure();
  const PhoneInput.dirty([super.value = '']) : super.dirty();
  static final regexPhone = RegExp(
    r'(\+62 ((\d{3}([ -]\d{3,})([- ]\d{4,})?)|(\d+)))|(\(\d+\) \d+)|\d{3}( \d+)+|(\d+[ -]\d+)|\d+',
  );

  static const minimumLength = 8;
  static const maximumLength = 15;
  @override
  PhoneInputValidationError? validator(String value) {
    if (!regexPhone.hasMatch(value)) {
      return PhoneInputValidationError.invalid;
    }
    final init = value.substring(0, 1);
    var data = value;
    if (init == '0') {
      data = value.substring(0);
    }
    if (data.length < minimumLength) {
      return PhoneInputValidationError.subceedingLength;
    }
    if (data.length > maximumLength) {
      return PhoneInputValidationError.exceedingLength;
    }

    return null;
  }
}

extension PhoneInputValidationErrorX on PhoneInputValidationError {
  String description() {
    switch (this) {
      case PhoneInputValidationError.invalid:
        return 'Nomor telepon tidak valid';
      case PhoneInputValidationError.subceedingLength:
        return 'Nomor telepon minimal 8 karakter';
      case PhoneInputValidationError.exceedingLength:
        return 'Nomor telepon maksimal 15 karakter';
    }
  }
}
