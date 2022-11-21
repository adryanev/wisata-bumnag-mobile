import 'package:flutter/material.dart';
import 'package:wisatabumnag/shared/orders/domain/entities/order.entity.dart';

class ReviewFormPage extends StatelessWidget {
  const ReviewFormPage({
    super.key,
    required this.orderDetail,
  });
  final OrderDetail orderDetail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello',
        ),
      ),
    );
  }
}
