import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:wisatabumnag/core/domain/entities/value_object.dart';
import 'package:wisatabumnag/core/domain/entities/value_validators.dart';
import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';

class UniqueId extends ValueObject<String> {
  factory UniqueId(String input) {
    return UniqueId._(validateUniqueId(input));
  }

  factory UniqueId.generate() {
    return UniqueId._(
      validateUniqueId(
        const Uuid().v4(),
      ),
    );
  }
  const UniqueId._(this.value);
  @override
  final Either<ValueFailure<String>, String> value;
}

class StringSingleLine extends ValueObject<String> {
  factory StringSingleLine(String input) {
    return StringSingleLine._(
      validateStringNotEmpty(input).flatMap(validateSingleLine),
    );
  }

  const StringSingleLine._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
