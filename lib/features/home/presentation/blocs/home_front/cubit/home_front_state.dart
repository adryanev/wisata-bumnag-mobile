part of 'home_front_cubit.dart';

@freezed
class HomeFrontState with _$HomeFrontState {
  const factory HomeFrontState({
    required Option<Either<Failure, List<Recommendation>>>
        recommendationsOrFailureOption,
    required List<Recommendation> recommendations,
    required Option<Either<Failure, List<AdBanner>>> adBannerOrFailureOption,
    required List<AdBanner> adBanners,
    required Option<Either<Failure, Location>> locationOrFailureOption,
    Location? location,
    required Option<Either<Failure, List<Category>>> categoryOrFailureOption,
    required List<Category> category,
  }) = _HomeFrontState;
  factory HomeFrontState.initial() => HomeFrontState(
        recommendationsOrFailureOption: none(),
        adBannerOrFailureOption: none(),
        locationOrFailureOption: none(),
        categoryOrFailureOption: none(),
        adBanners: [],
        category: [],
        recommendations: [],
      );
}
