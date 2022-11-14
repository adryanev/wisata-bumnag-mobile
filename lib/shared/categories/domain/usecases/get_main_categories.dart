import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/repositories/category_repository.dart';

@lazySingleton
class GetMainCategories extends UseCase<List<Category>, NoParams> {
  const GetMainCategories(this._repository);
  final CategoryRepository _repository;
  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      _repository.getMainCategory();
}
