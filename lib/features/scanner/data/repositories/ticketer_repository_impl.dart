import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/home/domain/mappers/order_history_item_mapper.dart';
import 'package:wisatabumnag/features/scanner/data/datasources/remote/ticketer_remote_data_source.dart';
import 'package:wisatabumnag/features/scanner/data/models/approve_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/payment_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/scan_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/approve_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/payment_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/scan_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/repositories/ticketer_repository.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

@LazySingleton(as: TicketerRepository)
class TicketerRepositoryImpl implements TicketerRepository {
  const TicketerRepositoryImpl(this._remoteDataSource);

  final TicketerRemoteDataSource _remoteDataSource;
  @override
  Future<Either<Failure, Unit>> approveTicket(ApproveTicketForm form) =>
      _remoteDataSource.approveTicket(ApproveTicketPayload.fromDomain(form));

  @override
  Future<Either<Failure, Unit>> payTicket(PaymentTicketForm form) =>
      _remoteDataSource.payTicket(PaymentTicketPayload.fromDomain(form));

  @override
  Future<Either<Failure, OrderHistoryItem>> scanTicket(ScanTicketForm form) =>
      _remoteDataSource.scanTicket(ScanTicketPayload.fromDomain(form)).then(
            (value) => value.map(
              (r) => OrderHistoryItemMapper.mapFromOrder(
                r.toDomain(),
              ),
            ),
          );
}
