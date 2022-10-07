import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/injector.dart';

Future<void> configureInjector() async {
  await configureDependencies(environment: Environment.test);
}
