import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_pasword_form.entity.dart';

part 'update_password_payload.model.freezed.dart';
part 'update_password_payload.model.g.dart';

@freezed
class UpdatePasswordPayload with _$UpdatePasswordPayload {
  const factory UpdatePasswordPayload({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) = _UpdatePasswordPayload;

  factory UpdatePasswordPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordPayloadFromJson(json);

  factory UpdatePasswordPayload.fromDomain(UpdatePasswordForm form) =>
      UpdatePasswordPayload(
        oldPassword: base64Encode(utf8.encode(form.oldPassword)),
        password: base64Encode(utf8.encode(form.password)),
        passwordConfirmation: base64Encode(
          utf8.encode(form.passwordConfirmation),
        ),
      );
}
