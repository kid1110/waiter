import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:tuihub_protos/librarian/sephirah/v1/sephirah.pb.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/tiphereth.pb.dart';

import '../common/bloc_event_status_mixin.dart';
import '../model/common_model.dart';
import '../model/tiphereth_model.dart';
import '../repo/grpc/api_helper.dart';
import '../repo/grpc/client.dart';
import '../repo/local/common.dart';
import '../repo/local/gebura.dart';
import '../repo/local/yesod.dart';
import 'chesed/chesed_bloc.dart';
import 'client_setting/client_setting_bloc.dart';
import 'gebura/gebura_bloc.dart';
import 'netzach/netzach_bloc.dart';
import 'tiphereth/tiphereth_bloc.dart';
import 'yesod/yesod_bloc.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final ApiHelper _api;
  final ClientCommonRepo _repo;
  final ClientSettingBloc _clientSettingBloc;
  final PackageInfo _packageInfo;
  final String? _basePath;

  TipherethBloc? _tipherethBloc;
  GeburaBloc? _geburaBloc;
  YesodBloc? _yesodBloc;
  ChesedBloc? _chesedBloc;
  NetzachBloc? _netzachBloc;

  ClientSettingBloc get clientSettingBloc => _clientSettingBloc;
  PackageInfo get packageInfo => _packageInfo;

  TipherethBloc? get tipherethBloc => _tipherethBloc;
  GeburaBloc? get geburaBloc => _geburaBloc;
  YesodBloc? get yesodBloc => _yesodBloc;
  ChesedBloc? get chesedBloc => _chesedBloc;
  NetzachBloc? get netzachBloc => _netzachBloc;

  Future<void> _initChild(MainState state) async {
    debugPrint(state.serverConfig!.host);
    final repoPath = _basePath != null
        ? path.join(
            _basePath!,
            '${state.serverConfig!.host}#${state.serverConfig!.port}',
            state.currentUser!.id.id.toHexString(),
          )
        : null;
    final geburaRepo = await GeburaRepo.init(repoPath);
    final yesodRepo = await YesodRepo.init(repoPath);

    _tipherethBloc = TipherethBloc(_api);
    _geburaBloc = GeburaBloc(_api, geburaRepo);
    _yesodBloc = YesodBloc(_api, yesodRepo);
    _chesedBloc = ChesedBloc(_api);
    _netzachBloc = NetzachBloc(_api);
  }

  void _pruneChild() {
    _tipherethBloc = null;
    _geburaBloc = null;
    _yesodBloc = null;
    _chesedBloc = null;
    _netzachBloc = null;
  }

  MainBloc(
    this._api,
    this._repo,
    this._clientSettingBloc,
    this._packageInfo,
    this._basePath,
  ) : super(MainState()) {
    final repo = _repo.get();

    on<MainAutoLoginEvent>((event, emit) async {
      emit(MainAutoLoginState(state, EventStatus.processing));
      if (repo.server != null) {
        var config = ServerConfig(
          repo.server!.host,
          repo.server!.port,
          repo.server!.tls,
          '',
        );
        emit(MainAutoLoginState(
            state.copyWith(serverConfig: config), EventStatus.processing));
        if (repo.server!.refreshToken != null) {
          try {
            final client = clientFactory(config: config);
            final refreshToken = repo.server!.refreshToken!;
            final resp = await client.refreshToken(RefreshTokenRequest(),
                options: withAuth(refreshToken));
            final user = await client.getUser(GetUserRequest(),
                options: withAuth(resp.accessToken));
            final info = await client.getServerInformation(
                GetServerInformationRequest(),
                options: withAuth(resp.accessToken));
            config = config.copyWith(refreshToken: resp.refreshToken);
            await _repo.set(repo.copyWith(server: config));
            _api.init(client, resp.accessToken, resp.refreshToken);
            final newState = MainAutoLoginState(
              state.copyWith(
                serverConfig: config,
                accessToken: resp.accessToken,
                currentUser: user.user,
                serverInfo: ServerInformation(
                  sourceCodeAddress: info.serverBinarySummary.sourceCodeAddress,
                  buildVersion: info.serverBinarySummary.buildVersion,
                  buildDate: info.serverBinarySummary.buildDate,
                  protocolVersion: info.protocolSummary.version,
                ),
              ),
              EventStatus.success,
            );
            await _initChild(newState);
            emit(newState);
            return;
          } catch (e) {
            debugPrint('login by refresh token failed');
          }
        }
      }
      debugPrint('login by refresh token failed');
      emit(MainAutoLoginState(state, EventStatus.failed));
    }, transformer: droppable());

    on<MainSetServerConfigEvent>((event, emit) async {
      emit(state.copyWith(serverConfig: event.config));
    });

    on<MainManualLoginEvent>((event, emit) async {
      if (state.serverConfig == null) {
        return;
      }
      emit(MainManualLoginState(state, EventStatus.processing));

      try {
        var config = state.serverConfig!;
        final client = clientFactory(config: config);
        final resp = await client.getToken(
          GetTokenRequest(username: event.username, password: event.password),
        );
        final user = await client.getUser(GetUserRequest(),
            options: withAuth(resp.accessToken));
        final info = await client.getServerInformation(
            GetServerInformationRequest(),
            options: withAuth(resp.accessToken));
        config = config.copyWith(refreshToken: resp.refreshToken);
        await _repo.set(repo.copyWith(server: config));
        _api.init(client, resp.accessToken, resp.refreshToken);
        final newState = MainManualLoginState(
          state.copyWith(
            serverConfig: config,
            accessToken: resp.accessToken,
            currentUser: user.user,
            serverInfo: ServerInformation(
              sourceCodeAddress: info.serverBinarySummary.sourceCodeAddress,
              buildVersion: info.serverBinarySummary.buildVersion,
              buildDate: info.serverBinarySummary.buildDate,
              protocolVersion: info.protocolSummary.version,
            ),
          ),
          EventStatus.success,
        );
        await _initChild(newState);
        emit(newState);
      } catch (e) {
        debugPrint(e.toString());
        emit(
            MainManualLoginState(state, EventStatus.failed, msg: e.toString()));
      }
    }, transformer: droppable());

    on<MainLogoutEvent>((event, emit) async {
      _pruneChild();
      await _repo.set(ClientCommonData(
        server: null,
        theme: repo.theme,
        themeMode: repo.themeMode,
      ));
      emit(MainState());
    });
  }

  int cacheSize() {
    return _yesodBloc?.cacheSize() ?? 0;
  }

  Future<void> clearCache() async {
    await _yesodBloc?.clearCache();
  }
}
