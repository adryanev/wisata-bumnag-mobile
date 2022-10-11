import 'dart:developer';

T safeCall<T>({
  required T Function() tryCallback,
  required T Function() exceptionCallBack,
}) {
  try {
    return tryCallback();
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);
    return exceptionCallBack();
  }
}
