import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_error_response.model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class BaseErrorResponse<T> extends Equatable {
  const BaseErrorResponse({required this.error});

  factory BaseErrorResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseErrorResponseFromJson<T>(json, fromJsonT);
  final T? error;

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T value) toJsonT,
  ) {
    return _$BaseErrorResponseToJson<T>(this, toJsonT);
  }

  @override
  List<Object?> get props => [error];
}
