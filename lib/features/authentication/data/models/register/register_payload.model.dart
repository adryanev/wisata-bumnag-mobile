import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_payload.model.freezed.dart';
part 'register_payload.model.g.dart';

@freezed
class RegisterPayload with _$RegisterPayload {
  const factory RegisterPayload(
      {@JsonKey(name: 'email') required String email,
      @JsonKey(name: 'password') required String password,
      @JsonKey(name: 'name') required String name}) = _RegisterPayload;

  factory RegisterPayload.fromJson(Map<String, dynamic> json) =>
      _$RegisterPayloadFromJson(json);
}
