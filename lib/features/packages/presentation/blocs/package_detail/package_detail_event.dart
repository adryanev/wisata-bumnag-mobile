part of 'package_detail_bloc.dart';

@freezed
class PackageDetailEvent with _$PackageDetailEvent {
  const factory PackageDetailEvent.started(String? packageId) =
      _PackageDetailStarted;
}
