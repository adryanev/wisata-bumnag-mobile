import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:wisatabumnag/shared/domain/entities/pagination.entity.dart';

@immutable
class Paginable<T> extends Equatable {
  const Paginable({required this.data, required this.pagination});

  final List<T> data;
  final Pagination pagination;

  @override
  List<Object?> get props => [data, pagination];

  Paginable<T> copyWith({
    List<T>? data,
    Pagination? pagination,
  }) {
    return Paginable<T>(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }
}
