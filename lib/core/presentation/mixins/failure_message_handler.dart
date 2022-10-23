import 'package:flutter/material.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';

mixin FailureMessageHandler {
  void handleFailure(BuildContext context, Failure failure) {
    failure.when(
      localFailure: (message) => context.displayFlash(message),
      serverFailure: (code, message) => context.displayFlash(message),
      networkMiddlewareFailure: (message) => context.displayFlash(message),
      unexpectedFailure: (message) => context.displayFlash(message),
      remoteConfigFailure: (message) => context.displayFlash(message),
    );
  }
}
