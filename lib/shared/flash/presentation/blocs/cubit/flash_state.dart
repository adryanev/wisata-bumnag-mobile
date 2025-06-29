part of 'flash_cubit.dart';

@freezed
abstract class FlashState with _$FlashState {
  const factory FlashState.disappeared() = FlashDisappeared;
  const factory FlashState.appeared(String message) = FlashAppeared;
}
