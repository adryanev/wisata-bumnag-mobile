import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/shared/orders/data/datasources/remote/client/order_client.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

abstract class OrderRemoteDataSource {
  Future<Either<Failure, OrderResponse>> createOrder(OrderPayload payload);
}

@LazySingleton(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  const OrderRemoteDataSourceImpl(this._client, this._provider);
  final OrderClient _client;
  final MiddlewareProvider _provider;
  @override
  Future<Either<Failure, OrderResponse>> createOrder(OrderPayload payload) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () =>
            _client.createOrder(payload).then((value) => value.data!),
      );
}
