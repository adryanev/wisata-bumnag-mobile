import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'destination_detail_event.dart';
part 'destination_detail_state.dart';
part 'destination_detail_bloc.freezed.dart';

@injectable
class DestinationDetailBloc
    extends Bloc<DestinationDetailEvent, DestinationDetailState> {
  DestinationDetailBloc() : super(DestinationDetailState.initial()) {
    on<DestinationDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
