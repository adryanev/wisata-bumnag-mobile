import 'package:freezed_annotation/freezed_annotation.dart';
part 'ad_banner.entity.freezed.dart';

@freezed
class AdBanner with _$AdBanner {
  const factory AdBanner({
    required int? id,
    required String name,
    required AdBannerAction? action,
    required String? target,
    required String media,
  }) = _AdBanner;
}

enum AdBannerAction {
  click,
}

class AdBannerActionMapper {
  const AdBannerActionMapper._();
  static AdBannerAction? mapFromString(String? action) {
    switch (action) {
      case 'click':
        return AdBannerAction.click;

      default:
        return null;
    }
  }
}
