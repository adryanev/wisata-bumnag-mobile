import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/approve_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/repositories/ticketer_repository.dart';

@lazySingleton
class ApproveTicket extends UseCase<Unit, ApproveTicketParams> {
  const ApproveTicket(this._repository);

  final TicketerRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(ApproveTicketParams params) =>
      _repository.approveTicket(params.form);
}

class ApproveTicketParams extends Equatable {
  const ApproveTicketParams(this.form);

  final ApproveTicketForm form;
  @override
  List<Object?> get props => [form];
}
