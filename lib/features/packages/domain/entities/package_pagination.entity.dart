import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
part 'package_pagination.entity.freezed.dart';

@freezed
class PackagePagination with _$PackagePagination {
  const factory PackagePagination({
    required List<Package> packages,
    required Pagination pagination,
  }) = _PackagePagination;
}
