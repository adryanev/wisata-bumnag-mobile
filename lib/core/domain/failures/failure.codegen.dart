import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.codegen.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.localFailure({
    required String message,
  }) = LocalFailure;
  const factory Failure.networkMiddlewareFailure({
    required String message,
  }) = NetworkMiddlewareFailure;
  const factory Failure.serverFailure({
    required int code,
    required String message,
  }) = ServerFailure;
  const factory Failure.remoteConfigFailure({
    required String message,
  }) = RemoteConfigFailure;
  const factory Failure.serverValidationFailure({
    required Map<String, dynamic> errors,
  }) = ServerValidationFailure;

  const factory Failure.locationFailure({
    required String message,
  }) = LocationFailure;

  const factory Failure.unexpectedFailure({
    required String message,
  }) = UnexpectedFailure;
}
