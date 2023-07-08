import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getMainCategory();
  Future<Either<Failure, List<Category>>> getCategoryByParent(
    Category category,
  );
}
