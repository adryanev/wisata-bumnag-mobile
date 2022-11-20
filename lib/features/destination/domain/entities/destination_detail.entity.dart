import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/reviewable.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'destination_detail.entity.freezed.dart';

@freezed
class DestinationDetail with _$DestinationDetail {
  const factory DestinationDetail({
    required int id,
    required String name,
    required String description,
    required String address,
    required String? phoneNumber,
    required String? email,
    required double? latitude,
    required double? longitude,
    required String? openingHours,
    required String? closingHours,
    required String? workingDay,
    required String? instagram,
    required String? website,
    required String? capacity,
    required List<Category> categories,
    required List<String> media,
    required Reviewable reviews,
    required List<Ticketable> tickets,
    required List<Destination> recommendations,
  }) = _DestinationDetail;
}
