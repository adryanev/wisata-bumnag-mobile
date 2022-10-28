import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'destination_result_event.dart';
part 'destination_result_state.dart';
part 'destination_result_bloc.freezed.dart';

@injectable
class DestinationResultBloc
    extends Bloc<DestinationResultEvent, DestinationResultState> {
  DestinationResultBloc() : super(_Initial()) {
    on<DestinationResultEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
