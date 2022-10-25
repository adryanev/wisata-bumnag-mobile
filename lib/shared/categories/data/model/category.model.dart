import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

part 'category.model.freezed.dart';
part 'category.model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
    required int? parentId,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromDomain(Category form) => CategoryModel(
        id: form.id,
        name: form.name,
        parentId: form.parentId,
      );
}

extension CategoryModelX on CategoryModel {
  Category toDomain() => Category(
        id: id,
        name: name,
        parentId: parentId,
      );
}
