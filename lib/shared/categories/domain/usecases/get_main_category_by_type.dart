import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/repositories/category_repository.dart';

@lazySingleton
class GetMainCategoryByType
    extends UseCase<Category, GetMainCategoryByTypeParams> {
  const GetMainCategoryByType(this._repository);
  final CategoryRepository _repository;
  @override
  Future<Either<Failure, Category>> call(GetMainCategoryByTypeParams params) =>
      _repository.getMainCategoryByType(params.type);
}

class GetMainCategoryByTypeParams extends Equatable {
  const GetMainCategoryByTypeParams(this.type);
  final MainCategoryType type;

  @override
  List<Object?> get props => [type];
}
