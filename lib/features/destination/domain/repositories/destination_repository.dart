import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination.entity.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class DestinationRepository {
  Future<Either<Failure, Paginable<Destination>>> getDestination({
    required Category category,
    required int page,
  });
  Future<Either<Failure, DestinationDetail>> getDestinationDetail({
    required String destinationId,
  });
}
