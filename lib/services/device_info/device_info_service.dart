import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/services/device_info/device_info_model.model.dart';

abstract class DeviceInfoService {
  Future<DeviceInfoModel> getDeviceInfo();
}

@LazySingleton(as: DeviceInfoService)
class DeviceInfoServiceImpl implements DeviceInfoService {
  const DeviceInfoServiceImpl(this._deviceInfo);
  final DeviceInfoPlugin _deviceInfo;

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return DeviceInfoModel(
        operatingSystem: 'Android',
        operatingSystemVersion: info.version.sdkInt.toString(),
        deviceInfo: info.product.toString(),
      );
    } else {
      final info = await _deviceInfo.iosInfo;
      return DeviceInfoModel(
        operatingSystem: 'iOS',
        operatingSystemVersion: info.systemVersion.toString(),
        deviceInfo: info.localizedModel.toString(),
      );
    }
  }
}
