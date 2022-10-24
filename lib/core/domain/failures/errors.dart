// ignore_for_file: strict_raw_type

import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';

class NoApiKeyError extends Error {
  @override
  String toString() {
    return 'No Api Key found in storage';
  }
}

class NoBaseUrlError extends Error {
  @override
  String toString() {
    return 'No Base URL found in storage';
  }
}

class UnexpectedValueError extends Error {
  UnexpectedValueError(this.valueFailure);
  final ValueFailure valueFailure;

  @override
  String toString() {
    const explanation =
        'Encountered a ValueFailure at an unrecoverable point. Terminating.';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}
