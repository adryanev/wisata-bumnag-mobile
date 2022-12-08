part of 'package_list_bloc.dart';

@freezed
class PackageListEvent with _$PackageListEvent {
  const factory PackageListEvent.started(Category category) =
      _PackageListStarted;

  const factory PackageListEvent.refreshed(Category category) =
      _PackageListRefreshed;
}
