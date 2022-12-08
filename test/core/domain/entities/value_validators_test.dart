import 'package:flutter_test/flutter_test.dart';
import 'package:wisatabumnag/core/domain/entities/value_validators.dart';
import 'package:wisatabumnag/core/domain/failures/value_failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';

void main() {
  group('Value Validator', () {
    group('Validate Single Line', () {
      test(
        'should return failure when multiline text.',
        () async {
          // arrange
          const input = 'this is the first line \n and this is the second one.';
          // act
          final validation = validateSingleLine(input);
          final output = validation.getRight();
          final failure = validation.getLeft();

          // assert
          expect(validation.isLeft(), isTrue);
          expect(output, isNull);
          expect(failure, isA<ValueFailureMultiLine<String>>());
        },
      );

      test(
        'should return String when validated',
        () async {
          // arrange
          const input = 'this is only single line';
          // act
          final validation = validateSingleLine(input);
          final output = validation.getRight();
          final failure = validation.getLeft();
          // assert
          expect(validation.isRight(), isTrue);
          expect(output, isA<String>());
          expect(output, equals(input));
          expect(failure, isNull);
        },
      );
    });

    group('Validate Unique Id', () {
      test(
        'should return Value Failure when invalid UUID',
        () async {
          // arrange
          const input = '10492';
          // act
          final validated = validateUniqueId(input);
          final output = validated.getRight();
          final failure = validated.getLeft();
          // assert
          expect(validated.isLeft(), isTrue);
          expect(failure, isA<ValueInvalidUniqueId<String>>());
          expect(output, isNull);
        },
      );

      test(
        'should return valid UUID String',
        () async {
          // arrange
          const input = 'f398a930-77b3-4395-be13-4bc5b53cb2f9';
          // act
          final validated = validateUniqueId(input);
          final output = validated.getRight();
          final failure = validated.getLeft();
          // assert
          expect(validated.isRight(), isTrue);
          expect(output, isA<String>());
          expect(output, equals(input));
          expect(failure, isNull);
        },
      );
    });
  });

  group('Validate Email Address', () {
    test(
      'should return failure when invalid email.',
      () async {
        // arrange
        const input = 'ad1312';
        // act
        final validation = validateEmailAddress(input);
        final output = validation.getRight();
        final failure = validation.getLeft();

        // assert
        expect(validation.isLeft(), isTrue);
        expect(output, isNull);
        expect(failure, isA<ValueInvalidEmailAddress<String>>());
      },
    );

    test(
      'should return String when validated',
      () async {
        // arrange
        const input = 'email@example.com';
        // act
        final validation = validateEmailAddress(input);
        final output = validation.getRight();
        final failure = validation.getLeft();
        // assert
        expect(validation.isRight(), isTrue);
        expect(output, isA<String>());
        expect(output, equals(input));
        expect(failure, isNull);
      },
    );
  });

  group('Validate Password', () {
    test(
      'should return failure when invalid password.',
      () async {
        // arrange
        const input = 'ad1312';
        // act
        final validation = validatePassword(input);
        final output = validation.getRight();
        final failure = validation.getLeft();

        // assert
        expect(validation.isLeft(), isTrue);
        expect(output, isNull);
        expect(failure, isA<ValueInvalidPassword<String>>());
      },
    );

    test(
      'should return String when validated',
      () async {
        // arrange
        const input = 'Asdf123@Baby';
        // act
        final validation = validatePassword(input);
        final output = validation.getRight();
        final failure = validation.getLeft();
        // assert
        expect(validation.isRight(), isTrue);
        expect(output, isA<String>());
        expect(output, equals(input));
        expect(failure, isNull);
      },
    );
  });
}
