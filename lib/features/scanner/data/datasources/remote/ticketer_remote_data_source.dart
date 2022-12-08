import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/networks/extensions.dart';
import 'package:wisatabumnag/core/networks/middlewares/providers/network_middleware_provider.dart';
import 'package:wisatabumnag/features/scanner/data/datasources/remote/client/ticketer_api_client.dart';
import 'package:wisatabumnag/features/scanner/data/models/approve_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/payment_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/scan_ticket_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

abstract class TicketerRemoteDataSource {
  Future<Either<Failure, OrderResponse>> scanTicket(ScanTicketPayload payload);
  Future<Either<Failure, Unit>> payTicket(PaymentTicketPayload payload);
  Future<Either<Failure, Unit>> approveTicket(ApproveTicketPayload payload);
}

@LazySingleton(as: TicketerRemoteDataSource)
class TicketerRemoteDataSourceImpl implements TicketerRemoteDataSource {
  const TicketerRemoteDataSourceImpl(this._provider, this._apiClient);

  final MiddlewareProvider _provider;
  final TicketerApiClient _apiClient;
  @override
  Future<Either<Failure, Unit>> approveTicket(ApproveTicketPayload payload) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.approveTicket(payload).then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, Unit>> payTicket(PaymentTicketPayload payload) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () => _apiClient.payTicket(payload).then(
              (value) => unit,
            ),
      );

  @override
  Future<Either<Failure, OrderResponse>> scanTicket(
    ScanTicketPayload payload,
  ) =>
      safeRemoteCall(
        middlewares: _provider.getAll(),
        retrofitCall: () =>
            _apiClient.scanTicket(payload).then((value) => value.data!),
      );
}
