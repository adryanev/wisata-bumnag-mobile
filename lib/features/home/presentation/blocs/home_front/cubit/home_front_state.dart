part of 'home_front_cubit.dart';

@freezed
abstract class HomeFrontState with _$HomeFrontState {
  const factory HomeFrontState({
    required Option<Either<Failure, List<Recommendation>>>
        recommendationsOrFailureOption,
    required List<Recommendation> recommendations,
    required Option<Either<Failure, List<AdBanner>>> adBannerOrFailureOption,
    required List<AdBanner> adBanners,
    required Option<Either<Failure, Location>> locationOrFailureOption,
    required Option<Either<Failure, List<Category>>> categoryOrFailureOption,
    required List<Category> category,
    Location? location,
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
