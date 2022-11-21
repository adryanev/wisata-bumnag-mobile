import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'review_form_event.dart';
part 'review_form_state.dart';
part 'review_form_bloc.freezed.dart';

@injectable
class ReviewFormBloc extends Bloc<ReviewFormEvent, ReviewFormState> {
  ReviewFormBloc() : super(ReviewFormState.initial()) {
    on<ReviewFormEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
