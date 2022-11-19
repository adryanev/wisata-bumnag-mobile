import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/souvenir/data/datasources/remote/souvenir_remote_data_source.dart';
import 'package:wisatabumnag/features/souvenir/data/models/destination_souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_detail_response.model.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/destination_souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir_detail.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/repositories/souvenir_repository.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

@LazySingleton(as: SouvenirRepository)
class SouvenirRepositoryImpl implements SouvenirRepository {
  const SouvenirRepositoryImpl(this._remoteSource);
  final SouvenirRemoteDataSource _remoteSource;
  @override
  Future<Either<Failure, List<Souvenir>>> getSouvenirByDestination(String id) =>
      _remoteSource.getSouvenirByDestination(id).then(
            (value) => value.map(
              (check) => check
                  .map(
                    (e) => e.toDomain(),
                  )
                  .toList(),
            ),
          );

  @override
  Future<Either<Failure, Paginable<DestinationSouvenir>>> getSouvenirs({
    required int page,
  }) =>
      _remoteSource.getSouvenirs(page: page).then(
            (value) => value.map(
              (r) => Paginable(
                data: r.data!.map((e) => e.toDomain()).toList(),
                pagination: r.meta.toDomain(),
              ),
            ),
          );

  @override
  Future<Either<Failure, SouvenirDetail>> getSouvenirDetail({
    required int souvenirId,
  }) =>
      _remoteSource.getSouvenirDetail(souvenirId: souvenirId.toString()).then(
            (value) => value.map(
              (r) => r.toDomain(),
            ),
          );
}
