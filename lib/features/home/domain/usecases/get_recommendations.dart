import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
import 'package:wisatabumnag/features/home/domain/repositories/home_front_repository.dart';

@lazySingleton
class GetRecommendations extends UseCase<List<Recommendation>, NoParams> {
  const GetRecommendations(this._repository);
  final HomeFrontRepository _repository;
  @override
  Future<Either<Failure, List<Recommendation>>> call(NoParams params) =>
      _repository.getRecommendations();
}
