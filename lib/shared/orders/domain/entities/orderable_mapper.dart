import 'package:wisatabumnag/features/souvenir/domain/entities/souvenir.entity.dart';
import 'package:wisatabumnag/shared/domain/entities/ticketable.entity.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';
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

class OrderableTypeMapper {
  const OrderableTypeMapper._();

  static OrderableType toOrderableType(String orderType) {
    switch (orderType) {
      case r'App\Models\Souvenir':
        return OrderableType.souvenir;
      case r'App\Models\Package':
        return OrderableType.package;
      case r'App\Models\Ticket':
        return OrderableType.ticket;
    }
    throw UnimplementedError('Orderable type not implemented yet');
  }

  static String toStringType(OrderableType orderType) {
    switch (orderType) {
      case OrderableType.ticket:
        return r'App\Models\Ticket';
      case OrderableType.souvenir:
        return r'App\Models\Souvenir';
      case OrderableType.package:
        return r'App\Models\Package';
    }
  }
}

class PaymentTypeMapper {
  const PaymentTypeMapper._();

  static String toText(PaymentType type) {
    switch (type) {
      case PaymentType.onsite:
        return 'Bayar di tempat';
      case PaymentType.online:
        return 'Bayar Online';
    }
  }

  static String toStringType(PaymentType type) {
    switch (type) {
      case PaymentType.onsite:
        return 'onsite';
      case PaymentType.online:
        return 'online';
    }
  }

  static PaymentType toPaymentType(String type) {
    switch (type) {
      case 'onsite':
        return PaymentType.onsite;
      case 'online':
        return PaymentType.online;
    }

    throw UnimplementedError('invalid payment type string');
  }
}
