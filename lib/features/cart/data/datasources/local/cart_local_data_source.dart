import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/storages/local_storages.dart';
import 'package:wisatabumnag/core/utils/utils.dart';
import 'package:wisatabumnag/features/cart/data/models/cart_souvenir_model.model.dart';

abstract class CartLocalDataSource {
  Future<Either<Failure, List<CartSouvenirModel>>> getUserCart();
  Future<Either<Failure, Unit>> saveCart(List<CartSouvenirModel> carts);
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  const CartLocalDataSourceImpl(this._storage);

  final LocalStorage _storage;
  @override
  Future<Either<Failure, List<CartSouvenirModel>>> getUserCart() async =>
      safeCall(
        tryCallback: () async {
          final data = await _storage.getUserCart();
          if (data == null) {
            return right(<CartSouvenirModel>[]);
          }
          return right(data);
        },
        exceptionCallBack: () => left(
          const Failure.localFailure(message: 'Cannot get user cart'),
        ),
      );

  @override
  Future<Either<Failure, Unit>> saveCart(List<CartSouvenirModel> carts) async =>
      safeCall(
        tryCallback: () async {
          await _storage.saveCart(carts);
          return right(unit);
        },
        exceptionCallBack: () {
          return left(
            const Failure.localFailure(message: 'Cannot save user cart'),
          );
        },
      );
}
