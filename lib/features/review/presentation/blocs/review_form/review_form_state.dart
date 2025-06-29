part of 'review_form_bloc.dart';

@freezed
abstract class ReviewFormState with _$ReviewFormState {
  const factory ReviewFormState({
    required String title,
    required String description,
    required OrderDetail? orderDetail,
    required List<XFile> media,
    required int rating,
    required Option<Either<Failure, Unit>> addReviewOrFailureOption,
    required bool isValid,
    required bool isSubmitting,
    required bool isLoading,
    required User? user,
  }) = _ReviewFormState;
  factory ReviewFormState.initial() => ReviewFormState(
        title: '',
        description: '',
        orderDetail: null,
        media: [],
        rating: 0,
        addReviewOrFailureOption: none(),
        isValid: false,
        isSubmitting: false,
        user: null,
        isLoading: false,
      );
}
