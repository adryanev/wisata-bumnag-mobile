part of 'review_form_bloc.dart';

@freezed
abstract class ReviewFormEvent with _$ReviewFormEvent {
  const factory ReviewFormEvent.started(OrderDetail orderDetail) =
      _ReviewFormStarted;
  const factory ReviewFormEvent.titleChanged(String title) =
      _ReviewFormTitleChanged;
  const factory ReviewFormEvent.descriptionChanged(String description) =
      _ReviewFormDescriptionChanged;
  const factory ReviewFormEvent.ratingChanged(int rating) =
      _ReviewFormRatingChanged;
  const factory ReviewFormEvent.photoPicked() = _ReviewFormPhotoPicked;
  const factory ReviewFormEvent.photoRemoved(int index) =
      _ReviewFormPhotoRemoved;
  const factory ReviewFormEvent.sendButtonPressed() =
      _ReviewFormSendButtonPressed;
}
