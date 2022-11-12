import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';

mixin FailureMessageHandler {
  void handleFailure(BuildContext context, Failure failure) {
    failure.when(
      localFailure: (message) => context.displayFlash(message),
      serverFailure: (code, message) {
        context.displayFlash(message);
        if (code == 401) {
          context.pushNamed(AppRouter.login);
        }
      },
      networkMiddlewareFailure: (message) => context.displayFlash(message),
      unexpectedFailure: (message) => context.displayFlash(message),
      remoteConfigFailure: (message) => context.displayFlash(message),
      serverValidationFailure: (Map<String, dynamic> errors) {
        final errorText = <String>[];
        errors.forEach((key, value) {
          final error = (value as List<dynamic>).join(', ');
          errorText.add('${key.toTitleCase()}: $error');
        });
        context.displayFlash(errorText.join('; '));
      },
      locationFailure: (message) => context.displayFlash(message),
    );
  }
}
