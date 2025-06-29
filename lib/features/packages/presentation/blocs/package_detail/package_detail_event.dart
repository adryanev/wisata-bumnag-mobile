part of 'package_detail_bloc.dart';

@freezed
abstract class PackageDetailEvent with _$PackageDetailEvent {
  const factory PackageDetailEvent.started(String? packageId) =
      _PackageDetailStarted;
}
