import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/home/domain/entities/ad_banner.entity.dart';
part 'ad_banner_response.model.freezed.dart';
part 'ad_banner_response.model.g.dart';

@freezed
abstract class AdBannerResponse with _$AdBannerResponse {
  const factory AdBannerResponse({
    required int? id,
    required String name,
    required String? action,
    required String? target,
    required String media,
  }) = _AdBannerResponse;

  factory AdBannerResponse.fromJson(Map<String, dynamic> json) =>
      _$AdBannerResponseFromJson(json);
}

extension AdBannerResponseX on AdBannerResponse {
  AdBanner toDomain() => AdBanner(
        id: id,
        name: name,
        action: AdBannerActionMapper.mapFromString(action),
        target: null,
        media: media,
      );
}
