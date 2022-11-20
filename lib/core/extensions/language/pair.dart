import 'package:flutter/foundation.dart';

@immutable
class Pair<First, Second> {
  const Pair(
    this.first,
    this.second,
  );
  final First first;
  final Second second;

  Pair<First, Second> copyWith({
    First? first,
    Second? second,
  }) {
    return Pair<First, Second>(
      first ?? this.first,
      second ?? this.second,
    );
  }

  @override
  String toString() => 'Pair(first: $first, second: $second)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pair<First, Second> &&
        other.first == first &&
        other.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
