import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
part 'pagination_response.model.freezed.dart';
part 'pagination_response.model.g.dart';

@freezed
class PaginationResponse with _$PaginationResponse {
  const factory PaginationResponse({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total') required int total,
  }) = _PaginationResponse;

  factory PaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginationResponseFromJson(json);
}

extension PaginationResponseX on PaginationResponse {
  Pagination toDomain() => Pagination(
        currentPage: currentPage,
        lastPage: lastPage,
        perPage: perPage,
        total: total,
      );
}
