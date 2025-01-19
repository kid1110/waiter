import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/netzach.pb.dart';

import '../../common/bloc_event_status_mixin.dart';
import '../../model/netzach_model.dart';
import '../../service/di_service.dart';
import '../../service/librarian_service.dart';

part 'netzach_event.dart';
part 'netzach_state.dart';

class NetzachBloc extends Bloc<NetzachEvent, NetzachState> {
  final DIProvider<LibrarianService> _api;

  NetzachBloc(this._api) : super(NetzachState()) {
    on<NetzachInitEvent>((event, emit) async {
      if (state.notifyTargets == null) {
        add(NetzachTargetLoadEvent());
        add(NetzachFlowLoadEvent());
      }
    });

    on<NetzachTargetLoadEvent>((event, emit) async {
      // emit(NetzachTargetLoadState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.listNotifyTargets,
      //     ListNotifyTargetsRequest(
      //       paging: PagingRequest(
      //         pageSize: Int64(1),
      //         pageNum: Int64(1),
      //       ),
      //     ));
      // late ListNotifyTargetsResponse data;
      // switch (resp) {
      //   case Ok():
      //     data = resp.v;
      //   case Err():
      //     emit(NetzachTargetLoadState(state, EventStatus.failed,
      //         msg: resp.error));
      //     return;
      // }
      //
      // final List<NotifyTarget> targets = [];
      // final totalSize = data.paging.totalSize.toInt();
      // const pageSize = 100;
      // var failCount = 0;
      //
      // for (var pageNum = 1; (pageNum - 1) * pageSize < totalSize; pageNum++) {
      //   final resp = await _api.doRequest(
      //     (client) => client.listNotifyTargets,
      //     ListNotifyTargetsRequest(
      //       paging: PagingRequest(
      //         pageSize: Int64(pageSize),
      //         pageNum: Int64(pageNum),
      //       ),
      //     ),
      //   );
      //   switch (resp) {
      //     case Ok():
      //       data = resp.v;
      //     case Err():
      //       failCount++;
      //   }
      // }
      //
      // emit(NetzachTargetLoadState(
      //   state.copyWith(notifyTargets: targets),
      //   failCount == 0 ? EventStatus.success : EventStatus.success,
      // ));
    });

    on<NetzachTargetAddEvent>((event, emit) async {
      // emit(NetzachTargetAddState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.createNotifyTarget,
      //     CreateNotifyTargetRequest(
      //       target: event.target,
      //     ));
      // if (resp case Err()) {
      //   emit(NetzachTargetAddState(state, EventStatus.failed, msg: resp.error));
      //   return;
      // }
      //
      // add(NetzachTargetLoadEvent());
      // emit(NetzachTargetAddState(
      //   state.copyWith(
      //       notifyTargets: [event.target, ...state.notifyTargets ?? []]),
      //   EventStatus.success,
      // ));
    });

    on<NetzachTargetEditEvent>((event, emit) async {
      // emit(NetzachTargetEditState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.updateNotifyTarget,
      //     UpdateNotifyTargetRequest(
      //       target: event.target,
      //     ));
      // if (resp case Err()) {
      //   emit(
      //       NetzachTargetEditState(state, EventStatus.failed, msg: resp.error));
      //   return;
      // }
      //
      // add(NetzachTargetLoadEvent());
      // emit(NetzachTargetEditState(
      //   state,
      //   EventStatus.success,
      // ));
    });

    on<NetzachFlowLoadEvent>((event, emit) async {
      // emit(NetzachFlowLoadState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.listNotifyFlows,
      //     ListNotifyFlowsRequest(
      //       paging: PagingRequest(
      //         pageSize: Int64(1),
      //         pageNum: Int64(1),
      //       ),
      //     ));
      // late ListNotifyFlowsResponse data;
      // switch (resp) {
      //   case Ok():
      //     data = resp.v;
      //   case Err():
      //     emit(
      //         NetzachFlowLoadState(state, EventStatus.failed, msg: resp.error));
      //     return;
      // }
      //
      // final List<NotifyFlow> flows = [];
      // final totalSize = data.paging.totalSize.toInt();
      // const pageSize = 100;
      // var failCount = 0;
      //
      // for (var pageNum = 1; (pageNum - 1) * pageSize < totalSize; pageNum++) {
      //   final resp = await _api.doRequest(
      //     (client) => client.listNotifyFlows,
      //     ListNotifyFlowsRequest(
      //       paging: PagingRequest(
      //         pageSize: Int64(pageSize),
      //         pageNum: Int64(pageNum),
      //       ),
      //     ),
      //   );
      //   switch (resp) {
      //     case Ok(value: final ListNotifyFlowsResponse d):
      //       flows.addAll(d.flows);
      //     case Err(value: final String _):
      //       failCount++;
      //   }
      // }
      //
      // emit(NetzachFlowLoadState(
      //   state.copyWith(notifyFlows: flows),
      //   failCount == 0 ? EventStatus.success : EventStatus.success,
      // ));
    });

    on<NetzachSetFlowEditIndexEvent>((event, emit) async {
      emit(state.copyWith(notifyFlowEditIndex: event.index));
    });

    on<NetzachFlowAddEvent>((event, emit) async {
      // emit(NetzachFlowAddState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.createNotifyFlow,
      //     CreateNotifyFlowRequest(
      //       flow: event.flow,
      //     ));
      // if (resp case Err()) {
      //   emit(NetzachFlowAddState(state, EventStatus.failed, msg: resp.error));
      //   return;
      // }
      //
      // add(NetzachFlowLoadEvent());
      // emit(NetzachFlowAddState(
      //   state.copyWith(notifyFlows: [event.flow, ...state.notifyFlows ?? []]),
      //   EventStatus.success,
      // ));
    });

    on<NetzachFlowEditEvent>((event, emit) async {
      // emit(NetzachFlowEditState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.updateNotifyFlow,
      //     UpdateNotifyFlowRequest(
      //       flow: event.flow,
      //     ));
      // if (resp case Err()) {
      //   emit(NetzachFlowEditState(state, EventStatus.failed, msg: resp.error));
      //   return;
      // }
      //
      // final flows = state.notifyFlows ?? [];
      // flows[state.notifyFlowEditIndex!] = event.flow;
      // add(NetzachFlowLoadEvent());
      // emit(NetzachFlowEditState(
      //   state.copyWith(notifyFlows: flows),
      //   EventStatus.success,
      // ));
    });

    on<NetzachSystemNotificationLoadEvent>((event, emit) async {
      // emit(NetzachSystemNotificationLoadState(state, EventStatus.processing));
      // final resp = await _api.doRequest(
      //     (client) => client.listSystemNotifications,
      //     ListSystemNotificationsRequest(
      //       paging: PagingRequest(
      //         pageSize: Int64(100),
      //         pageNum: Int64(event.page),
      //       ),
      //       typeFilter: state.systemNotificationFilter?.typeFilter,
      //       levelFilter: state.systemNotificationFilter?.levelFilter,
      //     ));
      // switch (resp) {
      //   case Ok():
      //     emit(NetzachSystemNotificationLoadState(
      //       state.copyWith(systemNotifications: resp.v.notifications),
      //       EventStatus.success,
      //     ));
      //   case Err():
      //     emit(NetzachSystemNotificationLoadState(state, EventStatus.failed,
      //         msg: resp.error));
      // }
    });

    on<NetzachSystemNotificationFilterSetEvent>((event, emit) async {
      emit(state.copyWith(systemNotificationFilter: event.filter));
      add(NetzachSystemNotificationLoadEvent(1));
    });
  }
}
