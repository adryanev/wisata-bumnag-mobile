import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';

abstract class NetworkMiddleware {
  NetworkMiddlewareFailure get failure;
  Future<bool> isValid();
}
