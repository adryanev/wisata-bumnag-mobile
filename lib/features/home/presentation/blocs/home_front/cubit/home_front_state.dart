part of 'home_front_cubit.dart';

@freezed
class HomeFrontState with _$HomeFrontState {
  const factory HomeFrontState({
    required Option<Either<Failure, List<Recommendation>>>
        recommendationsOrFailureOption,
    List<Recommendation>? recommendations,
    required Option<Either<Failure, List<AdBanner>>> adBannerOrFailureOption,
    List<AdBanner>? adBanners,
    required Option<Either<Failure, Location>> locationOrFailureOption,
    Location? location,
  }) = _HomeFrontState;
  factory HomeFrontState.initial() => HomeFrontState(
        recommendationsOrFailureOption: none(),
        adBannerOrFailureOption: none(),
        locationOrFailureOption: none(),
      );
}
