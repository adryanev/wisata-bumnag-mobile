import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/domain/repositories/cart_repository.dart';

@lazySingleton
class SaveCart extends UseCase<Unit, SaveCartParams> {
  const SaveCart(this._repository);

  final CartRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(SaveCartParams params) =>
      _repository.saveCart(params.cart);
}

class SaveCartParams extends Equatable {
  const SaveCartParams(this.cart);

  final List<CartSouvenir> cart;
  @override
  List<Object?> get props => [cart];
}
