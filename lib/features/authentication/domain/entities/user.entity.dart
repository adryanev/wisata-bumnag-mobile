import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/value_objects.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';
part 'user.entity.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required EmailAddress emailAddress,
    required Nik? nik,
    required PhoneNumber? phoneNumber,
    required StringSingleLine name,
    required String? roles,
  }) = _User;
}
