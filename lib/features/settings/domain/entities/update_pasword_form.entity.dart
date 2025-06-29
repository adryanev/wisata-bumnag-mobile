import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_pasword_form.entity.freezed.dart';

@freezed
abstract class UpdatePasswordForm with _$UpdatePasswordForm {
  const factory UpdatePasswordForm({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) = _UpdatePasswordForm;
}
