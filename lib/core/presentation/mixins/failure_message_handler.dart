import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/extensions/context_extensions.dart';

mixin FailureMessageHandler {
  void handleFailure(BuildContext context, Failure failure) {
    if (failure is ServerFailure) {
      if (failure.code == 401) {
        context.pushNamed(AppRouter.login);
      }
    }
    if (failure is ServerValidationFailure) {
      final errorText = <String>[];
      failure.errors.forEach((key, value) {
        final error = (value as List<dynamic>).join(', ');
        errorText.add('${key.toTitleCase()}: $error');
      });
    }

    if (failure is LocalFailure) {
      context.displayFlash(failure.message);
    }

    if (failure is NetworkMiddlewareFailure) {
      context.displayFlash(failure.message);
    }

    if (failure is UnexpectedFailure) {
      context.displayFlash(failure.message);
    }

    if (failure is RemoteConfigFailure) {
      context.displayFlash(failure.message);
    }

    if (failure is LocationFailure) {
      context.displayFlash(failure.message);
    }
  }
}
