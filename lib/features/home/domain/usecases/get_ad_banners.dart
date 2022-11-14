import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/home/domain/entities/ad_banner.entity.dart';
import 'package:wisatabumnag/features/home/domain/repositories/home_front_repository.dart';

@lazySingleton
class GetAdBanners extends UseCase<List<AdBanner>, NoParams> {
  const GetAdBanners(this._repository);
  final HomeFrontRepository _repository;
  @override
  Future<Either<Failure, List<AdBanner>>> call(NoParams params) =>
      _repository.getAdBanners();
}
