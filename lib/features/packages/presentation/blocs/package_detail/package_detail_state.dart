part of 'package_detail_bloc.dart';

@freezed
abstract class PackageDetailState with _$PackageDetailState {
  const factory PackageDetailState({
    required bool isLoading,
    required Option<Either<Failure, PackageDetail>>
        packageDetailOrFailureOption,
    required PackageDetail? packageDetail,
  }) = _PackageDetailState;
  factory PackageDetailState.initial() => PackageDetailState(
        isLoading: false,
        packageDetailOrFailureOption: none(),
        packageDetail: null,
      );
}
