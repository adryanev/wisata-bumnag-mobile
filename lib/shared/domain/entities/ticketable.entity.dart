import 'package:freezed_annotation/freezed_annotation.dart';
part 'ticketable.entity.freezed.dart';

@freezed
class Ticketable with _$Ticketable {
  const factory Ticketable({
    required int id,
    required String name,
    required double price,
    required bool isFree,
    required String? termAndConditions,
    required bool? isQuantityLimited,
    required String? quantity,
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required String? description,
    required String? ticketableType,
    required String? ticketableId,
  }) = _Ticketable;
}