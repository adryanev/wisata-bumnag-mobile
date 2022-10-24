import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_response.model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class BaseResponse<T> extends Equatable {
  const BaseResponse({required this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson<T>(json, fromJsonT);
  final T? data;

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T value) toJsonT,
  ) {
    return _$BaseResponseToJson<T>(this, toJsonT);
  }

  @override
  List<Object?> get props => [data];
}
