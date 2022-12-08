import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiLine(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<T>, T> validateNumberRange<T extends num>({
  required T minimum,
  required T maximum,
  required T number,
}) {
  if (number > maximum || number < minimum) {
    return left(
      ValueFailure.notInRange(
        failedValue: number,
        minimum: minimum,
        maximum: maximum,
      ),
    );
  } else {
    return right(number);
  }
}

Either<ValueFailure<String>, String> validateUniqueId(String input) {
  final regex = RegExp(
    '^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}',
  );
  if (regex.hasMatch(input)) {
    return right(input);
  }
  return left(ValueFailure.invalidUniqueId(failedValue: input));
}

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  final regex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  if (regex.hasMatch(input)) {
    return right(input);
  }
  return left(ValueFailure.invalidEmailAddress(failedValue: input));
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  const minLength = 8;

  final hasUppercase = input.contains(RegExp('[A-Z]'));
  final hasDigits = input.contains(RegExp('[0-9]'));
  final hasLowercase = input.contains(RegExp('[a-z]'));
  final hasMinLength = input.length >= minLength;

  if (hasDigits & hasUppercase & hasLowercase & hasMinLength) {
    return right(input);
  }
  return left(ValueFailure.invalidPassword(failedValue: input));
}

Either<ValueFailure<String>, String> validatePhoneNumber(String input) {
  if (input.contains(RegExp('[0.9]')) &&
      input.length >= 6 &&
      input.length < 16) {
    return right(input);
  }

  return left(ValueFailure.invalidPhoneNumber(failedValue: input));
}
