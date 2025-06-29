import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/utils/constants.dart' as env;
import 'package:wisatabumnag/injector.config.dart';

GetIt getIt = GetIt.instance;
const development = Environment(env.Environment.development);
const production = Environment(env.Environment.production);
const staging = Environment(env.Environment.staging);
const testing = Environment(env.Environment.test);

@InjectableInit(generateForDir: ['lib', 'test'])
Future<void> configureDependencies({required String environment}) async =>
    getIt.init(environment: environment);
