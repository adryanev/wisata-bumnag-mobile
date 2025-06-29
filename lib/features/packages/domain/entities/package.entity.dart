import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/review_aggregate.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
part 'package.entity.freezed.dart';

@freezed
abstract class Package with _$Package {
  const factory Package({
    required int id,
    required String name,
    required String? priceInclude,
    required String? priceExclude,
    required String? activities,
    required String? destination,
    required List<String> media,
    required List<Category> categories,
    required ReviewAggregate reviews,
    required List<Ticketable> tickets,
  }) = _Package;
}
