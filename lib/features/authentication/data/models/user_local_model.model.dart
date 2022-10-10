import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_local_model.model.freezed.dart';
part 'user_local_model.model.g.dart';

@freezed
class UserLocalModel with _$UserLocalModel {
  const factory UserLocalModel({
    required String email,
    required String? nik,
    required String name,
    required String? phoneNumber,
  }) = _UserLocalModel;

  factory UserLocalModel.fromJson(Map<String, dynamic> json) =>
      _$UserLocalModelFromJson(json);
}
