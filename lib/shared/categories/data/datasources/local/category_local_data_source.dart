import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/shared/categories/data/model/category.model.dart';

abstract class CategoryLocalDataSource {
  List<CategoryModel> getRootCategory();
  CategoryModel? getRootCategoryByName(String name);
}

@LazySingleton(as: CategoryLocalDataSource)
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final _categoryRoot = [
    const CategoryModel(id: 1, name: 'Wisata', parentId: null),
    const CategoryModel(id: 2, name: 'Event', parentId: null),
    const CategoryModel(id: 3, name: 'Kuliner', parentId: null),
    const CategoryModel(id: 4, name: 'Akomodasi', parentId: null),
    const CategoryModel(id: 5, name: 'Desa Wisata', parentId: null),
    const CategoryModel(id: 22, name: 'Souvenir', parentId: null),
    const CategoryModel(id: 25, name: 'Package', parentId: null),
  ];
  @override
  List<CategoryModel> getRootCategory() {
    return _categoryRoot;
  }

  @override
  CategoryModel? getRootCategoryByName(String name) {
    return _categoryRoot.firstWhereOrNull(
      (element) => element.name == name,
    );
  }
}
