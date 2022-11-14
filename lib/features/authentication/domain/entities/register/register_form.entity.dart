import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
part 'register_form.entity.freezed.dart';

@freezed
class RegisterForm with _$RegisterForm {
  const factory RegisterForm({
    required EmailAddress emailAddress,
    required Password password,
    required StringSingleLine fullName,
  }) = _RegisterForm;
}
