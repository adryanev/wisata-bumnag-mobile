import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/core/domain/usecases/use_case.dart';
import 'package:wisatabumnag/core/extensions/dartz_extensions.dart';
import 'package:wisatabumnag/features/home/domain/entities/ad_banner.entity.dart';
import 'package:wisatabumnag/features/home/domain/entities/recommendation.entity.dart';
import 'package:wisatabumnag/features/home/domain/usecases/get_ad_banners.dart';
import 'package:wisatabumnag/features/home/domain/usecases/get_recommendations.dart';
import 'package:wisatabumnag/features/notification/domain/entities/notification.entity.dart';
import 'package:wisatabumnag/features/notification/domain/usecases/get_notifications.dart';
import 'package:wisatabumnag/shared/categories/domain/entity/category.entity.dart';
import 'package:wisatabumnag/shared/categories/domain/usecases/get_main_categories.dart';
import 'package:wisatabumnag/shared/location/domain/entities/location.entity.dart';
import 'package:wisatabumnag/shared/location/domain/usecases/get_current_location.dart';

part 'home_front_state.dart';
part 'home_front_cubit.freezed.dart';

@injectable
class HomeFrontCubit extends Cubit<HomeFrontState> {
  HomeFrontCubit(
    this._getAdBanners,
    this._getRecommendations,
    this._getCurrentLocation,
    this._getMainCategories,
  ) : super(HomeFrontState.initial());

  final GetAdBanners _getAdBanners;
  final GetRecommendations _getRecommendations;
  final GetCurrentLocation _getCurrentLocation;
  final GetMainCategories _getMainCategories;

  FutureOr<void> getAdBanners() async {
    final result = await _getAdBanners(NoParams());
    if (result.isRight()) {
      emit(state.copyWith(adBanners: result.getRight()!));
    }
    emit(
      state.copyWith(
        adBannerOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        adBannerOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> getRecommendations() async {
    final result = await _getRecommendations(NoParams());
    if (result.isRight()) {
      emit(state.copyWith(recommendations: result.getRight()!));
    }
    emit(
      state.copyWith(
        recommendationsOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        recommendationsOrFailureOption: none(),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    final result = await _getCurrentLocation(NoParams());
    if (result.isRight()) {
      emit(state.copyWith(location: result.getRight()));
    }
    emit(
      state.copyWith(
        locationOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        locationOrFailureOption: none(),
      ),
    );
  }

  Future<void> getMainCategories() async {
    final result = await _getMainCategories(NoParams());
    if (result.isRight()) {
      emit(state.copyWith(category: result.getRight()!));
    }

    emit(
      state.copyWith(
        categoryOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        categoryOrFailureOption: none(),
      ),
    );
  }
}
