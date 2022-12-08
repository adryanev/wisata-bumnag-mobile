import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wisatabumnag/shared/data/models/pagination_response.model.dart';
part 'base_pagination_response.model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class BasePaginationResponse<T> extends Equatable {
  const BasePaginationResponse({
    required this.data,
    required this.meta,
  });

  factory BasePaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BasePaginationResponseFromJson<T>(json, fromJsonT);
  final T? data;
  final PaginationResponse meta;

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T value) toJsonT,
  ) {
    return _$BasePaginationResponseToJson<T>(this, toJsonT);
  }

  @override
  List<Object?> get props => [data, meta];
}
