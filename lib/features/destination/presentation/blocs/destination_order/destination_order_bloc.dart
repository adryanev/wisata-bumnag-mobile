import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';

part 'destination_order_event.dart';
part 'destination_order_state.dart';
part 'destination_order_bloc.freezed.dart';

@injectable
class DestinationOrderBloc
    extends Bloc<DestinationOrderEvent, DestinationOrderState> {
  DestinationOrderBloc() : super(DestinationOrderState.initial()) {
    on<DestinationOrderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
