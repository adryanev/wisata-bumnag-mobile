import 'package:flutter_test/flutter_test.dart';
import 'package:wisatabumnag/features/authentication/domain/entities/login/login_form.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/value_objects.dart';

void main() {
  group('LoginForm', () {
    test(
      'should be created when email and password is valid',
      () async {
        // arrange
        final email = EmailAddress('email@example.com');
        final password = Password('P@sw0rdV4lId');
        // act
        final form = LoginForm(emailAddress: email, password: password);
        // assert
        expect(form, isA<LoginForm>());
        expect(form.emailAddress, email);
        expect(form.password, password);
      },
    );
  });
}
