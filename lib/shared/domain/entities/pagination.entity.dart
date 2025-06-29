import 'package:freezed_annotation/freezed_annotation.dart';
part 'pagination.entity.freezed.dart';

@freezed
abstract class Pagination with _$Pagination {
  const factory Pagination({
    required int currentPage,
    required int lastPage,
    required int perPage,
    required int total,
  }) = _Pagination;
}
