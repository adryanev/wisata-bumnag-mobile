import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/repositories/category_repository.dart';

@lazySingleton
class GetCategoriesByParent
    extends UseCase<List<Category>, GetCategoriesByParentParams> {
  const GetCategoriesByParent(this._repository);
  final CategoryRepository _repository;
  @override
  Future<Either<Failure, List<Category>>> call(
    GetCategoriesByParentParams params,
  ) =>
      _repository.getCategoryByParent(params.category);
}

class GetCategoriesByParentParams extends Equatable {
  const GetCategoriesByParentParams({required this.category});
  final Category category;
  @override
  List<Object?> get props => [category];
}
