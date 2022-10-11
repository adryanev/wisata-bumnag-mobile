import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.codegen.freezed.dart';

@freezed
class Failure with _$Failure {
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

  const factory Failure.unexpectedFailure({
    required String message,
  }) = UnexpectedFailure;
}
