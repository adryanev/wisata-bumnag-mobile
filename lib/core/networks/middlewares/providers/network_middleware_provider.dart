import 'package:wisatabumnag/core/networks/middlewares/network_middleware.dart';

abstract class MiddlewareProvider {
  List<NetworkMiddleware> getAll();
}

class _MiddlewareProviderImpl implements MiddlewareProvider {
  _MiddlewareProviderImpl(this._middleware);
  final List<NetworkMiddleware> _middleware;
  @override
  List<NetworkMiddleware> getAll() {
    return _middleware;
  }
}

class MiddlewareProviderBuilder {
  MiddlewareProviderBuilder._();
  List<NetworkMiddleware> middlewareList = [];

  void addMiddleware(NetworkMiddleware middleware) {
    middlewareList.add(middleware);
  }

  MiddlewareProvider build() => _MiddlewareProviderImpl(middlewareList);
}
