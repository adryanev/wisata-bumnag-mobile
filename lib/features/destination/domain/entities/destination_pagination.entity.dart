import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
part 'destination_pagination.entity.freezed.dart';

@freezed
class DestinationPagination with _$DestinationPagination {
  const factory DestinationPagination({
    required List<Destination> destinations,
    required Pagination pagination,
  }) = _DestinationPagination;
}
