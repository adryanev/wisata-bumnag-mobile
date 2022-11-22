import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc() : super(ScannerInitial()) {
    on<ScannerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
