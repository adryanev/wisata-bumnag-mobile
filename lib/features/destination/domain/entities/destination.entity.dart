import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/review_aggregate.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'destination.entity.freezed.dart';

@freezed
class Destination with _$Destination {
  const factory Destination({
    required int id,
    required String name,
    required String description,
    required String? address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double? longitude,
    required String? openingHours,
    required String? closingHours,
    required String? workingDay,
    required String? instagram,
    required String? website,
    required int? capacity,
    required List<Category> categories,
    required List<String> media,
    required ReviewAggregate reviews,
    required List<Ticketable> tickets,
  }) = _Destination;
}
