import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';

Either<ValueFailure<String>, String> validateNik(String input) {
  if (input.length != 16) {
    return left(ValueFailure.invalidNik(failedValue: input));
  } else {
    return right(input);
  }
}
