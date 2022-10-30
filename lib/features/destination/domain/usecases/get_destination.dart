import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_pagination.entity.dart';
import 'package:wisatabumnag/features/destination/domain/repositories/destination_repository.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

@injectable
class GetDestination
    extends UseCase<DestinationPagination, GetDestinationParams> {
  const GetDestination(this._repository);
  final DestinationRepository _repository;

  @override
  Future<Either<Failure, DestinationPagination>> call(
    GetDestinationParams params,
  ) =>
      _repository.getDestination(category: params.category, page: params.page);
}

class GetDestinationParams extends Equatable {
  const GetDestinationParams({
    required this.category,
    this.page = 1,
  });
  final Category category;
  final int page;
  @override
  List<Object?> get props => [category, page];
}
