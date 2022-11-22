import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/approve_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/payment_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/scan_ticket_form.entity.dart';

abstract class TicketerRepository {
  Future<Either<Failure, OrderHistoryItem>> scanTicket(ScanTicketForm form);
  Future<Either<Failure, Unit>> payTicket(PaymentTicketForm form);
  Future<Either<Failure, Unit>> approveTicket(ApproveTicketForm form);
}
