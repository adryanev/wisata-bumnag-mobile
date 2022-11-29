import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/orders/data/models/midtrans_payment_response.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/payment_payload.model.dart';

part 'order_client.g.dart';

@lazySingleton
@RestApi()
abstract class OrderClient {
  @factoryMethod
  factory OrderClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _OrderClient;

  @POST('v1/orders')
  Future<BaseResponse<OrderResponse>> createOrder(@Body() OrderPayload payload);

  @POST('v1/payments')
  Future<MidtransPaymentResponse> payOnline(@Body() PaymentPayload payload);

  @GET('v1/orders')
  Future<BasePaginationResponse<List<OrderResponse>>> orderHistories({
    @Query('page') required int page,
  });
}
