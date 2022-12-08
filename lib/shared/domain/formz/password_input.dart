import 'package:formz/formz.dart';
import 'package:wisatabumnag/l10n/l10n.dart';

enum PasswordValidationError { invalid }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure([super.value = '']) : super.pure();
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    const minLength = 8;

    final hasUppercase = value.contains(RegExp('[A-Z]'));
    final hasDigits = value.contains(RegExp('[0-9]'));
    final hasLowercase = value.contains(RegExp('[a-z]'));
    final hasMinLength = value.length >= minLength;

    if (hasDigits & hasUppercase & hasLowercase & hasMinLength) {
      return null;
    }
    return PasswordValidationError.invalid;
  }
}

extension PasswordValidationErrorX on PasswordValidationError {
  String errorMessage(AppLocalizations i10n) {
    switch (this) {
      case PasswordValidationError.invalid:
        return i10n.invalidPassword;
    }
  }
}
