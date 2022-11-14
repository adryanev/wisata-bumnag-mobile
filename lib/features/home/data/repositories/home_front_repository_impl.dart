import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/data/datasources/remote/home_front_remote_data_source.dart';
import 'package:wisatabumnag/features/home/data/models/ad_banner_response.model.dart';
import 'package:wisatabumnag/features/home/data/models/recommendation_response.model.dart';
import 'package:wisatabumnag/features/home/domain/entities/ad_banner.entity.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
import 'package:wisatabumnag/features/home/domain/repositories/home_front_repository.dart';

@LazySingleton(as: HomeFrontRepository)
class HomeFrontRepositoryImpl implements HomeFrontRepository {
  const HomeFrontRepositoryImpl(this._dataSource);
  final HomeFrontRemoteDataSource _dataSource;
  @override
  Future<Either<Failure, List<AdBanner>>> getAdBanners() =>
      _dataSource.fetchAdBanners().then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );

  @override
  Future<Either<Failure, List<Recommendation>>> getRecommendations() =>
      _dataSource.fetchRecommendations().then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );
}
