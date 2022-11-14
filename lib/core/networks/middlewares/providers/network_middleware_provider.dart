// ignore_for_file: avoid_returning_this

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
  final List<NetworkMiddleware> _middlewareList = [];

  MiddlewareProviderBuilder addMiddleware(NetworkMiddleware middleware) {
    _middlewareList.add(middleware);
    return this;
  }

  MiddlewareProvider build() => _MiddlewareProviderImpl(_middlewareList);
}
