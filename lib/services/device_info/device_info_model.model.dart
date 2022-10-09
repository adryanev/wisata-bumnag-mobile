import 'package:freezed_annotation/freezed_annotation.dart';
part 'device_info_model.model.freezed.dart';
part 'device_info_model.model.g.dart';

@freezed
class DeviceInfoModel with _$DeviceInfoModel {
  const factory DeviceInfoModel({
    required String operatingSystem,
    required String operatingSystemVersion,
    required String deviceInfo,
    required String macAddress,
  }) = _DeviceInfoModel;

  factory DeviceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoModelFromJson(json);
}
