import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/core/utils/bloc_event_transformers.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/user.entity.dart';
import 'package:wisatabumnag/features/authentication/domain/usecases/get_logged_in_user.dart';
import 'package:wisatabumnag/features/review/domain/entities/review_form.entity.dart';
import 'package:wisatabumnag/features/review/domain/usecases/add_review.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

part 'review_form_event.dart';
part 'review_form_state.dart';
part 'review_form_bloc.freezed.dart';

@injectable
class ReviewFormBloc extends Bloc<ReviewFormEvent, ReviewFormState> {
  ReviewFormBloc(
    this._addReview,
    this._getLoggedInUser,
  ) : super(ReviewFormState.initial()) {
    on<_ReviewFormStarted>(_onStarted);
    on<_ReviewFormTitleChanged>(
      _onTitleChanged,
      transformer: debounceRestartable(
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
    on<_ReviewFormDescriptionChanged>(
      _onDescriptionChanged,
      transformer: debounceRestartable(
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
    on<_ReviewFormRatingChanged>(
      _onRatingChanged,
    );
    on<_ReviewFormPhotoPicked>(
      _onPhotoPicked,
    );
    on<_ReviewFormPhotoRemoved>(
      _onPhotoRemoved,
    );
    on<_ReviewFormSendButtonPressed>(
      _onSendButtonPressed,
    );
  }

  final AddReview _addReview;
  final GetLoggedInUser _getLoggedInUser;

  FutureOr<void> _onTitleChanged(
    _ReviewFormTitleChanged event,
    Emitter<ReviewFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onDescriptionChanged(
    _ReviewFormDescriptionChanged event,
    Emitter<ReviewFormState> emit,
  ) {
    emit(state.copyWith(description: event.description));
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onRatingChanged(
    _ReviewFormRatingChanged event,
    Emitter<ReviewFormState> emit,
  ) {
    emit(state.copyWith(rating: event.rating));
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onPhotoPicked(
    _ReviewFormPhotoPicked event,
    Emitter<ReviewFormState> emit,
  ) async {
    final _picker = ImagePicker();
    // Pick an image
    final image = await _picker.pickMultiImage();
    emit(state.copyWith(media: [...state.media, ...image]));
  }

  FutureOr<void> _onPhotoRemoved(
    _ReviewFormPhotoRemoved event,
    Emitter<ReviewFormState> emit,
  ) {
    emit(state.copyWith(media: state.media..removeAt(event.index)));
    emit(state.copyWith(isValid: _isValid));
  }

  FutureOr<void> _onSendButtonPressed(
    _ReviewFormSendButtonPressed event,
    Emitter<ReviewFormState> emit,
  ) async {
    if (!state.isValid) {
      return null;
    }
    emit(state.copyWith(isSubmitting: true));

    final result = await _addReview(
      AddReviewParams(
        ReviewForm(
          title: state.title,
          description: state.description,
          rating: state.rating,
          user: state.user!,
          orderDetail: state.orderDetail!,
          media: state.media.map((e) => File(e.path)).toList(),
        ),
      ),
    );

    emit(
      state.copyWith(
        addReviewOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        isSubmitting: false,
        addReviewOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _onStarted(
    _ReviewFormStarted event,
    Emitter<ReviewFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final loggedIn = await _getLoggedInUser(NoParams());
    if (loggedIn.isLeft()) {
      return;
    }
    final user = loggedIn.getRight();
    emit(state.copyWith(orderDetail: event.orderDetail, user: user));
    emit(state.copyWith(isLoading: false));
  }

  bool get _isValid =>
      state.title.isNotEmpty &&
      state.description.isNotEmpty &&
      !state.rating.isNegative;
}
