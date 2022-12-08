import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/domain/entities/ad_banner.entity.dart';
import 'package:wisatabumnag/features/home/domain/entities/explore.entity.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/paginable.dart';

abstract class HomeFrontRepository {
  Future<Either<Failure, List<AdBanner>>> getAdBanners();
  Future<Either<Failure, List<Recommendation>>> getRecommendations();
  Future<Either<Failure, Paginable<Explore>>> getExplore({
    required int page,
  });
}
