import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
part 'login_response.model.freezed.dart';
part 'login_response.model.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'user') required UserDataResponse user,
    @JsonKey(name: 'authorization')
    required AuthorizationDataResponse authorization,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class UserDataResponse with _$UserDataResponse {
  const factory UserDataResponse({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'email') required String? email,
    @JsonKey(name: 'nik') required String? nik,
    @JsonKey(name: 'phone_number') required String? phoneNumber,
    @JsonKey(name: 'name') required String? name,
    @JsonKey(name: 'roles') required String? roles,
    @JsonKey(name: 'avatar') required String? avatar,
  }) = _UserDataResponse;

  factory UserDataResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDataResponseFromJson(json);
}

extension UserDataResponseX on UserDataResponse {
  User toDomain() => User(
        id: id,
        emailAddress: EmailAddress(email!),
        nik: nik == null ? null : Nik(nik!),
        phoneNumber: phoneNumber == null ? null : PhoneNumber(phoneNumber!),
        name: StringSingleLine(name!),
        roles: roles,
        avatar: avatar,
      );
}

@freezed
abstract class AuthorizationDataResponse with _$AuthorizationDataResponse {
  const factory AuthorizationDataResponse({
    @JsonKey(name: 'token') required String? accessToken,
  }) = _AuthorizationDataResponse;

  factory AuthorizationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthorizationDataResponseFromJson(json);
}
