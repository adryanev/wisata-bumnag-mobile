import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_failure.codegen.freezed.dart';

@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.empty({required T failedValue}) =
      ValueFailureEmpty<T>;
  const factory ValueFailure.multiLine({required T failedValue}) =
      ValueFailureMultiLine<T>;

  const factory ValueFailure.notInRange({
    required T failedValue,
    required T minimum,
    required T maximum,
  }) = ValueNotInRange<T>;

  const factory ValueFailure.invalidUniqueId({
    required T failedValue,
  }) = ValueInvalidUniqueId<T>;

  const factory ValueFailure.invalidEmailAddress({
    required T failedValue,
  }) = ValueInvalidEmailAddress<T>;

  const factory ValueFailure.invalidPassword({
    required T failedValue,
  }) = ValueInvalidPassword<T>;

  const factory ValueFailure.invalidNik({
    required T failedValue,
  }) = ValueInvalidNik<T>;

  const factory ValueFailure.invalidPhoneNumber({
    required T failedValue,
  }) = ValueInvalidPhoneNumber<T>;
}
