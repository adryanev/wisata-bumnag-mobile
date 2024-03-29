import 'package:collection/collection.dart';
import 'package:wisatabumnag/features/packages/domain/entities/amenity.entity.dart';
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
        media: null,
        subtotal: ticketable.price * 1,
      );
  static Orderable fromSouvenir(Souvenir souvenir) => Orderable(
        type: OrderableType.souvenir,
        id: souvenir.id,
        name: souvenir.name,
        price: souvenir.price,
        media: souvenir.media.firstOrNull,
        quantity: 1,
        subtotal: souvenir.price * 1,
      );
  static Orderable fromAmenity(Amenity amenity) => Orderable(
        type: OrderableType.amenity,
        id: amenity.id,
        name: amenity.name,
        price: amenity.price,
        quantity: 1,
        media: null,
        subtotal: amenity.price * 1,
      );
}

class OrderableTypeMapper {
  const OrderableTypeMapper._();

  static OrderableType toOrderableType(String orderType) {
    switch (orderType) {
      case r'App\Models\Souvenir':
        return OrderableType.souvenir;

      case r'App\Models\Ticket':
        return OrderableType.ticket;

      case r'App\Models\PackageAmenities':
        return OrderableType.amenity;
    }
    throw UnimplementedError('Orderable type not implemented yet');
  }

  static String toStringType(OrderableType orderType) {
    switch (orderType) {
      case OrderableType.ticket:
        return r'App\Models\Ticket';
      case OrderableType.souvenir:
        return r'App\Models\Souvenir';
      case OrderableType.amenity:
        return r'App\Models\PackageAmenities';
    }
  }
}

class PaymentTypeMapper {
  const PaymentTypeMapper._();

  static String toText(PaymentType type) {
    switch (type) {
      case PaymentType.online:
        return 'Bayar Online';
    }
  }

  static String toStringType(PaymentType type) {
    switch (type) {
      case PaymentType.online:
        return 'online';
    }
  }

  static PaymentType toPaymentType(String type) {
    switch (type) {
      case 'online':
        return PaymentType.online;
    }

    throw UnimplementedError('invalid payment type string');
  }
}

class OrderStatusMapper {
  const OrderStatusMapper._();

  static String toText(OrderStatus status) {
    switch (status) {
      case OrderStatus.created:
        return 'Dibuat';
      case OrderStatus.paid:
        return 'Dibayar';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.refunded:
        return 'Dikembalikan';
    }
  }

  static OrderStatus fromResponse(int status) {
    switch (status) {
      case 0:
        return OrderStatus.created;
      case 1:
        return OrderStatus.paid;
      case 2:
        return OrderStatus.cancelled;
      case 3:
        return OrderStatus.completed;
      case 4:
        return OrderStatus.refunded;
    }
    throw UnimplementedError('invalid order status');
  }
}
