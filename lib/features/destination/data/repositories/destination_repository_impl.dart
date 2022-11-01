import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/destination/data/datasources/remote/destination_remote_data_source.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_detail_response.model.dart';
import 'package:wisatabumnag/features/destination/data/models/destination_response.model.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_pagination.entity.dart';
import 'package:wisatabumnag/features/destination/domain/repositories/destination_repository.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';

@LazySingleton(as: DestinationRepository)
class DestinationRepositoryImpl implements DestinationRepository {
  const DestinationRepositoryImpl(this._remoteSource);
  final DestinationRemoteDataSource _remoteSource;
  @override
  Future<Either<Failure, DestinationPagination>> getDestination({
    required Category category,
    required int page,
  }) =>
      _remoteSource.getDestination(categoryId: category.id, page: page).then(
            (value) => value.map(
              (r) => DestinationPagination(
                destinations: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );

  @override
  Future<Either<Failure, DestinationDetail>> getDestinationDetail({
    required String destinationId,
  }) =>
      _remoteSource.getDestinationDetail(destinationId: destinationId).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );
}
