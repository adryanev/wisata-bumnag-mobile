import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/settings/domain/entities/update_profile_form.entity.dart';
part 'update_profile_payload.model.freezed.dart';
part 'update_profile_payload.model.g.dart';

@freezed
abstract class UpdateProfilePayload with _$UpdateProfilePayload {
  const factory UpdateProfilePayload({
    required String name,
    required String? nik,
    required String? phoneNumber,
  }) = _UpdateProfilePayload;
  factory UpdateProfilePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfilePayloadFromJson(json);

  factory UpdateProfilePayload.fromDomain(UpdateProfileForm form) =>
      UpdateProfilePayload(
        name: form.name,
        nik: form.nik,
        phoneNumber: form.phoneNumber,
      );
}
