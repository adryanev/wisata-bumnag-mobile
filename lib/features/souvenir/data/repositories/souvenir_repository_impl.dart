import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/souvenir/data/datasources/remote/souvenir_remote_data_source.dart';
import 'package:wisatabumnag/features/souvenir/data/models/souvenir_response.model.dart';
import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/features/souvenir/domain/repositories/souvenir_repository.dart';

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
}
