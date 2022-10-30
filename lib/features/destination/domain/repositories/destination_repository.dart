import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_pagination.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';

abstract class DestinationRepository {
  Future<Either<Failure, DestinationPagination>> getDestination({
    required Category category,
    required int page,
  });
}
