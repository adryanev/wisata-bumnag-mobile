import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/review/domain/entities/review_form.entity.dart';
import 'package:wisatabumnag/features/review/domain/repositories/review_repository.dart';

@lazySingleton
class AddReview extends UseCase<Unit, AddReviewParams> {
  const AddReview(this._repository);

  final ReviewRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(AddReviewParams params) =>
      _repository.addReview(params.form);
}

class AddReviewParams extends Equatable {
  const AddReviewParams(this.form);

  final ReviewForm form;
  @override
  List<Object?> get props => [form];
}
