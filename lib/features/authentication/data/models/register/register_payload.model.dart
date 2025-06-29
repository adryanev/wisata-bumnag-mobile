import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/register/register_form.entity.dart';
part 'register_payload.model.freezed.dart';
part 'register_payload.model.g.dart';

@freezed
abstract class RegisterPayload with _$RegisterPayload {
  const factory RegisterPayload({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'password') required String password,
    @JsonKey(name: 'name') required String name,
  }) = _RegisterPayload;

  factory RegisterPayload.fromJson(Map<String, dynamic> json) =>
      _$RegisterPayloadFromJson(json);

  factory RegisterPayload.fromDomain(RegisterForm form) {
    final encoded = base64Encode(utf8.encode(form.password.getOrCrash()));
    return RegisterPayload(
      email: form.emailAddress.getOrCrash(),
      password: encoded,
      name: form.fullName.getOrCrash(),
    );
  }
}
