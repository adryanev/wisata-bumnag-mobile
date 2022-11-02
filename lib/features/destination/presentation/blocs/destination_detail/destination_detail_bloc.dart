import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/destination/domain/entities/destination_detail.entity.dart';

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
