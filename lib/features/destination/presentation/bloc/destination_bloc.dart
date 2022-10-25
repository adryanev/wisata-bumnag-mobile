import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'destination_event.dart';
part 'destination_state.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  DestinationBloc() : super(DestinationInitial()) {
    on<DestinationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
