import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/event/domain/entities/event.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';
part 'event_pagination.entity.freezed.dart';

@freezed
class EventPagination with _$EventPagination {
  const factory EventPagination({
    required List<Event> events,
    required Pagination pagination,
  }) = _EventPagination;
}
