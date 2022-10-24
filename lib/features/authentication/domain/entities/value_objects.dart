import 'package:dartz/dartz.dart';
import 'package:wisatabumnag/core/domain/entities/value_object.dart';
import 'package:wisatabumnag/core/domain/entities/value_validators.dart';
import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/value_validators.dart';

class Nik extends ValueObject<String> {
  factory Nik(String input) {
    return Nik._(
      validateStringNotEmpty(input).flatMap(validateNik),
    );
  }

  const Nik._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
