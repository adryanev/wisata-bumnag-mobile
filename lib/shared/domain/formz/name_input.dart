import 'package:formz/formz.dart';
import 'package:wisatabumnag/l10n/l10n.dart';

enum NameErrorValidation { empty }

class NameInput extends FormzInput<String, NameErrorValidation> {
  const NameInput.pure([super.value = '']) : super.pure();
  const NameInput.dirty([super.value = '']) : super.dirty();

  @override
  NameErrorValidation? validator(String value) {
    return value.isEmpty ? NameErrorValidation.empty : null;
  }
}

extension NameErrorValidationX on NameErrorValidation {
  String errorMessage(AppLocalizations i10n) {
    switch (this) {
      case NameErrorValidation.empty:
        return i10n.cannotBeEmpty(i10n.name);
    }
  }
}
