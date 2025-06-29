// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get invalidEmail => 'Invalid Email Address';

  @override
  String get invalidPassword =>
      'Password must be at least 8 characters and contain at least capital letter, one letter, and number';

  @override
  String get confirmPasswordMismatch => 'Password confirmation not match';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get history => 'History';

  @override
  String get account => 'Account';

  @override
  String cannotBeEmpty(String field) {
    return '$field cannot be empty';
  }

  @override
  String get name => 'Name';
}
