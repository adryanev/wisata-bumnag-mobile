import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/orderable.entity.dart';

class OrderableMapper {
  const OrderableMapper._();

  static Orderable fromTicket(Ticketable ticketable) => Orderable(
        type: OrderableType.ticket,
        id: ticketable.id,
        name: ticketable.name,
        price: ticketable.price,
        quantity: 1,
        subtotal: ticketable.price * 1,
      );
  static Orderable fromSouvenir(Souvenir souvenir) => Orderable(
        type: OrderableType.souvenir,
        id: souvenir.id,
        name: souvenir.name,
        price: souvenir.price,
        quantity: 1,
        subtotal: souvenir.price * 1,
      );
}
