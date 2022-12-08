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
    on<_SplashFetchApiUrl>(_fetchApiUrl);
    on<_SplashSaveApiUrl>(_saveApiUrl);
    on<_SplashFetchApiKey>(_fetchApiKey);
    on<_SplashSaveApiKey>(_saveApiKey);
    on<_SplashFetchSalt>(_fetchSalt);
    on<_SplashSaveSalt>(_saveSalt);
    on<_SplashFetchMapApiKey>(_fetchMapApiKey);
    on<_SplashSaveMapApiKey>(_saveMapApiKey);
    on<_SplashFetchTncUrl>(_fetchTncUrl);
    on<_SplashSaveTncUrl>(_saveTncUrl);
  }

  final FetchRemoteConfig _fetchRemoteConfig;
  final SaveRemoteConfig _saveRemoteConfig;

  FutureOr<void> _fetchApiUrl(
    _SplashFetchApiUrl event,
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
    _SplashSaveApiUrl event,
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
    _SplashFetchApiKey event,
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
    _SplashSaveApiKey event,
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
    _SplashFetchSalt event,
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
    _SplashSaveSalt event,
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
    _SplashFetchMapApiKey event,
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
    _SplashSaveMapApiKey event,
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

  FutureOr<void> _fetchTncUrl(
    _SplashFetchTncUrl event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _fetchRemoteConfig(
      const FetchRemoteConfigParams(
        remoteConfigType: RemoteConfigType.tncUrl,
      ),
    );
    emit(
      state.copyWith(
        tncUrlOrFailureOption: optionOf(result),
      ),
    );
    emit(
      state.copyWith(
        tncUrlOrFailureOption: none(),
      ),
    );
  }

  FutureOr<void> _saveTncUrl(
    _SplashSaveTncUrl event,
    Emitter<SplashState> emit,
  ) async {
    final result = await _saveRemoteConfig(
      SaveRemoteConfigParams(
        config: event.config,
      ),
    );

    emit(
      state.copyWith(
        saveTncUrlOrFailureOption: optionOf(
          result,
        ),
      ),
    );
    emit(
      state.copyWith(
        saveTncUrlOrFailureOption: none(),
      ),
    );
  }
}
