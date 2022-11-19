import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/domain/repositories/cart_repository.dart';

@lazySingleton
class GetUserCart extends UseCase<List<CartSouvenir>, NoParams> {
  const GetUserCart(this._repository);

  final CartRepository _repository;
  @override
  Future<Either<Failure, List<CartSouvenir>>> call(NoParams params) =>
      _repository.getUserCart();
}
