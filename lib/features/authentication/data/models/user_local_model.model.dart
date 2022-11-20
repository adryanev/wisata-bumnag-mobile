import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/data/models/login/login_response.model.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
part 'user_local_model.model.freezed.dart';
part 'user_local_model.model.g.dart';

@freezed
class UserLocalModel with _$UserLocalModel {
  const factory UserLocalModel({
    required String email,
    required String? nik,
    required String name,
    required String? phoneNumber,
    required String? roles,
  }) = _UserLocalModel;

  factory UserLocalModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocalModelFromJson(json);
  factory UserLocalModel.fromRemoteModel(UserDataResponse response) =>
      UserLocalModel(
        email: response.email!,
        nik: response.nik,
        name: response.name!,
        phoneNumber: response.phoneNumber,
        roles: response.roles,
      );
}

extension UserLocalModelX on UserLocalModel {
  User toDomain() => User(
        emailAddress: EmailAddress(email),
        nik: nik == null ? null : Nik(nik!),
        phoneNumber: phoneNumber == null ? null : PhoneNumber(phoneNumber!),
        name: StringSingleLine(name),
        roles: roles,
      );
}
