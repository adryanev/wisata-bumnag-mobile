import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';

part 'login_form.entity.freezed.dart';

@freezed
class LoginForm with _$LoginForm {
  const factory LoginForm({
    required EmailAddress emailAddress,
    required Password password,
  }) = _LoginForm;
}
