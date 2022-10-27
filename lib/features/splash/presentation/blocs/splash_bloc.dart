import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:wisatabumnag/core/domain/failures/failure.codegen.dart';
import 'package:wisatabumnag/features/splash/domain/usecases/fetch_remote_config.dart';
import 'package:wisatabumnag/features/splash/domain/usecases/save_remote_config.dart';
import 'package:wisatabumnag/services/remote_config/remote_config.entity.dart';

part 'splash_event.dart';
part 'splash_state.dart';
part 'splash_bloc.freezed.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._fetchRemoteConfig, this._saveRemoteConfig)
      : super(SplashState.initial()) {
    on<SplashFetchApiUrl>(_fetchApiUrl);
    on<SplashSaveApiUrl>(_saveApiUrl);
    on<SplashFetchApiKey>(_fetchApiKey);
    on<SplashSaveApiKey>(_saveApiKey);
    on<SplashFetchSalt>(_fetchSalt);
    on<SplashSaveSalt>(_saveSalt);
    on<SplashFetchMapApiKey>(_fetchMapApiKey);
    on<SplashSaveMapApiKey>(_saveMapApiKey);
  }

  final FetchRemoteConfig _fetchRemoteConfig;
  final SaveRemoteConfig _saveRemoteConfig;

  FutureOr<void> _fetchApiUrl(
    SplashFetchApiUrl event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _fetchRemoteConfig(
      const FetchRemoteConfigParams(
        remoteConfigType: RemoteConfigType.apiUrl,
      ),
    );
    emit(
      state.copyWith(
        apiUrlOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        apiUrlOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _saveApiUrl(
    SplashSaveApiUrl event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _saveRemoteConfig(
      SaveRemoteConfigParams(
        config: event.config,
      ),
    );

    emit(
      state.copyWith(
        saveApiUrlOrFailureOption: optionOf(
          result,
        ),
      ),
    );
    emit(
      state.copyWith(
        saveApiUrlOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _fetchApiKey(
    SplashFetchApiKey event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _fetchRemoteConfig(
      const FetchRemoteConfigParams(
        remoteConfigType: RemoteConfigType.apiKey,
      ),
    );

    emit(
      state.copyWith(
        apiKeyOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        apiKeyOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _saveApiKey(
    SplashSaveApiKey event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _saveRemoteConfig(
      SaveRemoteConfigParams(
        config: event.config,
      ),
    );

    emit(
      state.copyWith(
        saveApiKeyOrFailureOption: optionOf(
          result,
        ),
      ),
    );
    emit(
      state.copyWith(
        saveApiKeyOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _fetchSalt(
    SplashFetchSalt event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _fetchRemoteConfig(
      const FetchRemoteConfigParams(
        remoteConfigType: RemoteConfigType.salt,
      ),
    );

    emit(
      state.copyWith(
        saltOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        saltOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _saveSalt(
    SplashSaveSalt event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _saveRemoteConfig(
      SaveRemoteConfigParams(
        config: event.config,
      ),
    );

    emit(
      state.copyWith(
        saveSaltOrFailureOption: optionOf(
          result,
        ),
      ),
    );
    emit(
      state.copyWith(
        saveSaltOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _fetchMapApiKey(
    SplashFetchMapApiKey event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _fetchRemoteConfig(
      const FetchRemoteConfigParams(
        remoteConfigType: RemoteConfigType.mapApiKey,
      ),
    );

    emit(
      state.copyWith(
        mapApiKeyOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        mapApiKeyOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _saveMapApiKey(
    SplashSaveMapApiKey event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _saveRemoteConfig(
      SaveRemoteConfigParams(
        config: event.config,
      ),
    );

    emit(
      state.copyWith(
        saveMapApiKeyOrFailureOption: optionOf(
          result,
        ),
      ),
    );
    emit(
      state.copyWith(
        saveMapApiKeyOrFailureOption: none(),
      ),
    );
  }
}
