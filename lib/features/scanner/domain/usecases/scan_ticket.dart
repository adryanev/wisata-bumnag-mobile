import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/home/domain/entities/order_history_item.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/scan_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/repositories/ticketer_repository.dart';

@lazySingleton
class ScanTicket extends UseCase<OrderHistoryItem, ScanTicketParams> {
  const ScanTicket(this._repository);

  final TicketerRepository _repository;
  @override
  Future<Either<Failure, OrderHistoryItem>> call(ScanTicketParams params) =>
      _repository.scanTicket(params.form);
}

class ScanTicketParams extends Equatable {
  const ScanTicketParams(this.form);

  final ScanTicketForm form;
  @override
  List<Object?> get props => [form];
}
