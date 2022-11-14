import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.entity.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required int? parentId,
  }) = _Category;
}

enum MainCategoryType {
  wisata,
  package,
  event,
  souvenir,
  kuliner,
  akomodasi,
  desaWisata;
}

extension MainCategoryTypeX on MainCategoryType {
  String toStringName() {
    switch (this) {
      case MainCategoryType.wisata:
        return 'Wisata';
      case MainCategoryType.package:
        return 'Package';
      case MainCategoryType.event:
        return 'Event';
      case MainCategoryType.souvenir:
        return 'Souvenir';
      case MainCategoryType.kuliner:
        return 'Kuliner';
      case MainCategoryType.akomodasi:
        return 'Akomodasi';
      case MainCategoryType.desaWisata:
        return 'Desa Wisata';
    }
  }
}
