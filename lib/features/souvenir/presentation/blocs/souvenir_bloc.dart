import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'souvenir_event.dart';
part 'souvenir_state.dart';

class SouvenirBloc extends Bloc<SouvenirEvent, SouvenirState> {
  SouvenirBloc() : super(SouvenirInitial()) {
    on<SouvenirEvent>((event, emit) {});
  }
}
