import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/cart/data/datasources/local/cart_local_data_source.dart';
import 'package:wisatabumnag/features/cart/data/models/cart_souvenir_model.model.dart';
import 'package:wisatabumnag/features/cart/domain/entities/cart_souvenir.entity.dart';
import 'package:wisatabumnag/features/cart/domain/repositories/cart_repository.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;
  @override
  Future<Either<Failure, List<CartSouvenir>>> getUserCart() =>
      _localDataSource.getUserCart().then(
            (value) => value.map(
              (r) => r.map((e) => e.toDomain()).toList(),
            ),
          );

  @override
  Future<Either<Failure, Unit>> saveCart(List<CartSouvenir> cart) =>
      _localDataSource
          .saveCart(cart.map(CartSouvenirModel.fromDomain).toList());
}
