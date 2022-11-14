import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/features/packages/domain/entities/package.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/reviewable.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';

part 'package_detail.entity.freezed.dart';

@freezed
class PackageDetail with _$PackageDetail {
  const factory PackageDetail({
    required int id,
    required String name,
    required String? priceInclude,
    required String? priceExclude,
    required String? activities,
    required String? destination,
    required List<String> media,
    required List<Category> categories,
    required Reviewable reviews,
    required List<Ticketable> tickets,
    required List<Package> recommendations,
  }) = _PackageDetail;
}
