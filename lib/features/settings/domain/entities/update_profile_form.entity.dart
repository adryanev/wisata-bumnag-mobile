import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_profile_form.entity.freezed.dart';

@freezed
abstract class UpdateProfileForm with _$UpdateProfileForm {
  const factory UpdateProfileForm({
    required String name,
    required String? nik,
    required String? phoneNumber,
  }) = _UpdateProfileForm;
}
