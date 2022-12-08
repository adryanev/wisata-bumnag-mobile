import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';

abstract class CartRepository {
  Future<Either<Failure, Unit>> saveCart(List<CartSouvenir> cart);
  Future<Either<Failure, List<CartSouvenir>>> getUserCart();
}
