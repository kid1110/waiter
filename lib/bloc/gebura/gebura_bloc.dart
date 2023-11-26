import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/widgets.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/gebura.pb.dart';
import 'package:tuihub_protos/librarian/v1/common.pb.dart';

import '../../common/api/api_helper.dart';

part 'gebura_event.dart';
part 'gebura_state.dart';

class GeburaBloc extends Bloc<GeburaEvent, GeburaState> {
  final ApiHelper api;

  GeburaBloc(this.api) : super(GeburaState()) {
    on<GeburaInitEvent>((event, emit) async {
      if (state.purchasedApps == null) {
        add(GeburaPurchasedAppsLoadEvent());
      }
    });

    on<GeburaPurchasedAppsLoadEvent>((event, emit) async {
      debugPrint('GeburaPurchasedAppsLoadEvent');
      emit(GeburaPurchasedAppsLoadState(
          state, GeburaRequestStatusCode.processing));
      final resp = await api.doRequest(
        (client) => client.getPurchasedApps,
        GetPurchasedAppsRequest(),
      );
      if (resp.status != ApiStatus.success) {
        emit(GeburaPurchasedAppsLoadState(state, GeburaRequestStatusCode.failed,
            msg: resp.error));
        return;
      }
      emit(GeburaPurchasedAppsLoadState(
          state.copyWith(purchasedApps: resp.getData().apps),
          GeburaRequestStatusCode.success,
          msg: resp.error));
    }, transformer: droppable());

    on<GeburaSetPurchasedAppIndexEvent>((event, emit) async {
      emit(state.copyWith(selectedPurchasedAppIndex: event.index));
    });

    on<GeburaSearchAppsEvent>((event, emit) async {
      emit(GeburaSearchAppsState(state, GeburaRequestStatusCode.processing));
      final resp = await api.doRequest(
        (client) => client.searchApps,
        SearchAppsRequest(
          paging: PagingRequest(
            pageSize: 10,
            pageNum: 1,
          ),
          keywords: event.query,
        ),
      );
      if (resp.status != ApiStatus.success) {
        emit(GeburaSearchAppsState(state, GeburaRequestStatusCode.failed,
            msg: resp.error));
        return;
      }
      final appMap = state.storeApps ?? <InternalID, App>{};
      for (final app in resp.getData().apps) {
        appMap[app.id] = app;
      }
      emit(GeburaSearchAppsState(
        state.copyWith(storeApps: appMap),
        GeburaRequestStatusCode.success,
        msg: resp.error,
        apps: resp.getData().apps,
      ));
    }, transformer: droppable());

    on<GeburaPurchaseEvent>((event, emit) async {
      emit(GeburaPurchaseState(state, GeburaRequestStatusCode.processing));
      final resp = await api.doRequest(
        (client) => client.purchaseApp,
        PurchaseAppRequest(
          appId: event.id,
        ),
      );
      if (resp.status != ApiStatus.success) {
        emit(GeburaPurchaseState(state, GeburaRequestStatusCode.failed,
            msg: resp.error));
        return;
      }
      emit(GeburaPurchaseState(state, GeburaRequestStatusCode.success,
          msg: resp.error));
      add(GeburaPurchasedAppsLoadEvent());
    }, transformer: droppable());
  }
}
