import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/features/scanner/domain/entities/payment_ticket_form.entity.dart';
import 'package:wisatabumnag/features/scanner/domain/repositories/ticketer_repository.dart';

@lazySingleton
class PayTicket extends UseCase<Unit, PayTicketParams> {
  const PayTicket(this._repository);

  final TicketerRepository _repository;
  @override
  Future<Either<Failure, Unit>> call(PayTicketParams params) =>
      _repository.payTicket(params.form);
}

class PayTicketParams extends Equatable {
  const PayTicketParams(this.form);

  final PaymentTicketForm form;
  @override
  List<Object?> get props => [form];
}
