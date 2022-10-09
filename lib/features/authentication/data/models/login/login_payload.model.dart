import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/services/device_info/device_info_service.dart';
part 'login_payload.model.freezed.dart';
part 'login_payload.model.g.dart';

@freezed
class LoginPayload with _$LoginPayload {
  const factory LoginPayload({
    @JsonKey(name: 'email') required String emailAddress,
    @JsonKey(name: 'password') required String password,
    @JsonKey(name: 'os') required String operatingSystem,
    @JsonKey(name: 'os_version') required String operatingSystemVersion,
    @JsonKey(name: 'device_info') required String deviceInfo,
    @JsonKey(name: 'mac_address') required String macAddress,
  }) = _LoginPayload;

  factory LoginPayload.fromJson(Map<String, dynamic> json) =>
      _$LoginPayloadFromJson(json);
}

class LoginPayloadFactory {
  const LoginPayloadFactory(this._deviceInfoService);
  final DeviceInfoService _deviceInfoService;

  Future<LoginPayload> createFromLoginForm(LoginForm form) async {
    final deviceInfo = await _deviceInfoService.getDeviceInfo();
    return LoginPayload(
      emailAddress: form.emailAddress.getOrCrash(),
      password: form.password.getOrCrash(),
      operatingSystem: deviceInfo.operatingSystem,
      operatingSystemVersion: deviceInfo.operatingSystemVersion,
      deviceInfo: deviceInfo.deviceInfo,
      macAddress: deviceInfo.macAddress,
    );
  }
}
