import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/features/scanner/data/models/approve_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/payment_ticket_payload.model.dart';
import 'package:wisatabumnag/features/scanner/data/models/scan_ticket_payload.model.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

part 'ticketer_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class TicketerApiClient {
  @factoryMethod
  factory TicketerApiClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _TicketerApiClient;

  @POST('v1/ticketers/check')
  Future<BaseResponse<OrderResponse>> scanTicket(
    @Body() ScanTicketPayload payload,
  );

  @POST('v1/ticketers/payment')
  Future<BaseResponse<String>> payTicket(
    @Body() PaymentTicketPayload payload,
  );

  @POST('v1/ticketers/approve')
  Future<BaseResponse<String>> approveTicket(
    @Body() ApproveTicketPayload payload,
  );
}
