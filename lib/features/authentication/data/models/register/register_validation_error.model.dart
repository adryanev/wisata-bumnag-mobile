import 'package:freezed_annotation/freezed_annotation.dart';
part 'register_validation_error.model.freezed.dart';
part 'register_validation_error.model.g.dart';

@freezed
class RegisterError with _$RegisterError {
  const factory RegisterError({
    @JsonKey(name: 'name') required List<String>? name,
    @JsonKey(name: 'email') required List<String>? email,
    @JsonKey(name: 'password') required List<String>? password,
  }) = _RegisterError;

  factory RegisterError.fromJson(Map<String, dynamic> json) =>
      _$RegisterErrorFromJson(json);
}
