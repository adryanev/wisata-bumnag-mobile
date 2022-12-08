import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:wisatabumnag/core/networks/models/base_pagination_response.model.dart';
import 'package:wisatabumnag/core/networks/models/base_response.model.dart';
import 'package:wisatabumnag/core/utils/constants.dart';
import 'package:wisatabumnag/shared/orders/data/models/order_response.model.dart';

part 'review_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class ReviewApiClient {
  @factoryMethod
  factory ReviewApiClient(@Named(InjectionConstants.privateDio) Dio dio) =
      _ReviewApiClient;

  @GET('v1/reviews')
  Future<BasePaginationResponse<List<OrderDetailResponse>>>
      getWaitingForReview({
    @Query('page') required int page,
  });
  @GET('v1/reviews/history')
  Future<BasePaginationResponse<List<OrderDetailResponse>>> getHistoryReview({
    @Query('page') required int page,
  });

  @MultiPart()
  @POST('v1/reviews')
  Future<BaseResponse<String>> addReview({
    @Part() required String title,
    @Part() required String description,
    @Part() required int rating,
    @Part(name: 'user_id') required int userId,
    @Part(name: 'order_detail_id') required int orderDetailId,
    @Part(name: 'reviewable_type') required String orderableType,
    @Part(name: 'reviewable_id') required int reviewableId,
    @Part(name: 'media[]') required List<File>? media,
  });
}
